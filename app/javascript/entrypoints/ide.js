/* Editor */
const tabRefs = [];
let activeTab = -1;

const buttonEvts = [];

/**
 * Redraw all elements within the tab navigation from tabRefs
 */
function redrawNav() {
  $("#content-nav").empty();

  // Display a message if no tabs are open and skip processing
  if (!tabRefs.length) {
    $("#content-nav").append("<li class=\"nav-item\"><a class=\"nav-link\" disabled>No tabs are currently open.</a></li>");
    return;
  }

  for (const [i, tab] of tabRefs.entries()) {
    const tabButton = $(`<a class="nav-link" href="#">${tab.name}</a>`);

    if (i === activeTab) {
      tabButton.addClass("active");
    }

    tabButton.on("click", () => {
      activateTab(i);
    });

    const tabItem = $(`<li class="nav-item"></li>`).append(tabButton);
    $("#content-nav").append(tabItem);
  }
}

/**
 * Activate a tab by index to switch to that editor
 *
 * @param {number} index the index of the tab to activate
 */
function activateTab(index) {
  // Skip doing anything if no tabs are open
  if (!tabRefs.length) return;

  $("#content-ide-tabs")
    .children()
    .each((i, child) => {
      if (i === index) {
        $(child).addClass("active").addClass("show");
      } else {
        $(child).removeClass("active").removeClass("show");
      }
    });
  activeTab = index;

  redrawNav();
}

/**
 * Create a new tab on the editor, and switch to it if no other tabs are
 * present. `redrawNav` should be run after creating this to update the
 * navigation.
 *
 * @param {string} codeToInsert the code to insert into the new editor (if applicable)
 * @param {string} tabName the name to give the new editor tab (will default to file#.js)
 */
function createTab(codeToInsert, tabName) {
  // Create the DOM item to inject for the tab
  const nextTab = tabRefs.length;
  const newTab = $("#template-tab")
    .clone()
    .prop("id", "tab-" + nextTab);

  newTab.children("#editor").prop("id", "editor-" + nextTab);
  $("#content-ide-tabs").append(newTab);

  // Initialize the editor
  const tabEditor = ace.edit("editor-" + nextTab);
  tabEditor.getSession().setMode("ace/mode/javascript");
  tabEditor.setShowPrintMargin(false);
  // tabEditor.setTheme("ace/theme/tomorrow"); // Use default theme

  if (codeToInsert) {
    tabEditor.insert(codeToInsert);
  }

  // Add the reference to tabRefs for future use
  tabRefs.push({
    tab: newTab,
    editor: tabEditor,
    name: tabName || `file${tabRefs.length}.js`,
  });

  // If added as the first tab, activate it and (re)enable the delete tab button
  if (activeTab === -1) {
    activateTab(0);
  }
}

/**
 * Delete the currently-active tab (specified by activeTab) and switch to
 * another available tab. `redrawNav` should be run after this to update
 * the navigation.
 */
function deleteTab() {
  if (
    !confirm(
      `Are you sure you want to delete "${tabRefs[activeTab].name}"?\nThis action is not reversible!`,
    )
  )
    return;

  if (tabRefs.length <= 1) {
    tabRefs.length = 0;
    activeTab = -1;

    $("#content-ide-tabs").empty();

    return;
  }

  const indexToDelete = activeTab;
  $("tab-" + indexToDelete).remove();
  tabRefs.splice(indexToDelete, 1);

  activateTab(Math.max(indexToDelete - 1, 0));
}

function renameTab() {
  // Skip if no tabs are open or no active tab
  if (activeTab === -1 || !tabRefs.length) return;

  const currentTab = tabRefs[activeTab];
  const newName = prompt('Enter a new name for the current file:', currentTab.name);

  if (!newName) return; // User cancelled or entered empty string

  // Basic file name validation
  const validFileName = newName.trim().replace(/[^a-zA-Z0-9-_.\s]/g, '');

  // Ensure the filename has a .js extension
  const fileName = validFileName.endsWith('.js') ? validFileName : `${validFileName}.js`;

  // Update the tab name in our reference array
  currentTab.name = fileName;

  // Redraw navigation to show the new name
  redrawNav();
}

/* Backend interop */
let isResubmit = false;

/**
 * Handles sending a code file to the backend for processing.
 *
 * @param {string} name the name of the code file to send
 * @param {string} content the content of the code file to send; will be hex-encoded
 * @returns a promise that resolves with the response ID from the backend
 */
async function sendCodeToBackend(name, content) {
  function hexEncode(str) {
    let hex, i;
    let result = "";
    for (i = 0; i < str.length; i++) {
      hex = str.charCodeAt(i).toString(16);
      result += ("000" + hex).slice(-4);
    }
    return result;
  }

  return new Promise((resolve, reject) => {
    $.post("/ide_internal/send_code", {
      name: name,
      content: hexEncode(content),
    })
      .then((data) => resolve(data))
      .catch((error) => reject(error));
  });
}

/**
 * Save the code project. Will redirect to the project details page after
 * sending the corresponding editor file data over.
 */
async function postCode(e) {
  try {
    const requests = {
      ids: [],
      posts: [],
    };

    for (const ref of tabRefs) {
      try {
        const data = await sendCodeToBackend(ref.name, ref.editor.getValue());
        if (data.id !== null) {
          requests.ids.push(data.id);
        }
      } catch (error) {
        throw new Error(`Failed to send code: ${error.message || error}`);
      }
    }

    const ids = requests.ids.join("-");
    const params = { ...e.params, ids };

    if (e.no_further_query) {
      const url = e.split_action_url + "?" + $.param(params);
      loadResult(url, e.new_window, e.text);
    } else {
      const response = await $.get(e.split_action_url, params);
      const url = e.redirect_url + "?query=" + encodeURIComponent(response.query);
      loadResult(url, e.new_window, e.text);
    }
  } catch (error) {
    throw new Error(`Failed to process code: ${error.message || error}`);
  }
}

/* Runtime */


/**
 * Initialize the drag functionality for the split screen resizer
 */
function initDragResize() {
  const container = document.querySelector('.split-screen-container');
  const codePanel = document.querySelector('#content-ide-tabs');
  const resultPanel = document.querySelector('#result-frame-container');
  const resizer = document.createElement('div');
  resizer.className = 'resizer';

  // Insert resizer between panels
  container.insertBefore(resizer, resultPanel);

  let isResizing = false;
  let startX;
  let startWidthCode;
  let startWidthResult;

  resizer.addEventListener('mousedown', (e) => {
    isResizing = true;
    startX = e.pageX;

    // Get starting widths as percentages
    startWidthCode = parseFloat(getComputedStyle(codePanel).width) / container.offsetWidth * 100;
    startWidthResult = parseFloat(getComputedStyle(resultPanel).width) / container.offsetWidth * 100;

    document.addEventListener('mousemove', handleMouseMove);
    document.addEventListener('mouseup', stopResizing);

    // Add class to indicate resizing is active
    container.classList.add('resizing');
  });

  function handleMouseMove(e) {
    if (!isResizing) return;

    e.preventDefault();

    // Calculate the difference in pixels
    const diffX = e.pageX - startX;
    const containerWidth = container.offsetWidth;

    // Convert pixel difference to percentage
    const diffPercentage = (diffX / containerWidth) * 100;

    // Update widths based on original position plus movement
    let newWidthCode = Math.min(Math.max(startWidthCode + diffPercentage, 20), 80);
    let newWidthResult = Math.min(Math.max(startWidthResult - diffPercentage, 20), 80);

    // Apply new widths
    codePanel.style.width = `${newWidthCode}%`;
    resultPanel.style.width = `${newWidthResult}%`;

    // Ensure editors resize properly
    resizeEditor();
  }

  function stopResizing() {
    isResizing = false;
    document.removeEventListener('mousemove', handleMouseMove);
    document.removeEventListener('mouseup', stopResizing);
    container.classList.remove('resizing');
  }
}

/**
 * Toggle the split screen layout based on the provided enabled state.
 * 
 * @param {boolean} enabled whether to enable the split screen layout
 */
function toggleSplitScreen(enabled) {
  const codePanel = document.querySelector('#content-ide-tabs');
  const resultPanel = document.querySelector('#result-frame-container');
  const splitScreenBtn = document.querySelector('#split-screen-btn');

  if (enabled) {
    $(".split-screen-container").addClass("active");
    $("#result-frame-container").show();
    $(".resizer").show();
    splitScreenBtn.classList.add('active');

    // Reset to default 50-50 split when enabling
    codePanel.style.width = '50%';
    resultPanel.style.width = '50%';
  } else {
    $(".split-screen-container").removeClass("active");
    $("#result-frame-container").hide();
    $(".resizer").hide();
    splitScreenBtn.classList.remove('active');

    // Reset the code panel to full width
    codePanel.style.width = '100%';
    resultPanel.style.width = '0';
  }
  resizeEditor();
}

/**
 * Ensure the editor properly resizes when the layout changes.
 */
function resizeEditor() {
  tabRefs.forEach(ref => {
    if (ref.editor) {
      ref.editor.resize();
    }
  });
}

/**
 * Save and restore the scroll position of the result frame.
 */
function initScrollPositionMaintenance() {
  const resultFrame = document.getElementById('result-frame');
  let lastScrollPosition = 0;

  resultFrame.addEventListener('load', () => {
    const iframeDocument = resultFrame.contentDocument || resultFrame.contentWindow.document;

    // Restore last scroll position
    iframeDocument.body.scrollTop = lastScrollPosition;
    iframeDocument.documentElement.scrollTop = lastScrollPosition;

    // Save scroll position when scrolling
    iframeDocument.addEventListener('scroll', () => {
      lastScrollPosition = Math.max(iframeDocument.body.scrollTop, iframeDocument.documentElement.scrollTop);
    });

    // Reapply scroll position after any DOM changes
    const mutationObserver = new MutationObserver(() => {
      iframeDocument.body.scrollTop = lastScrollPosition;
      iframeDocument.documentElement.scrollTop = lastScrollPosition;
    });

    mutationObserver.observe(iframeDocument.body, {
      childList: true,
      subtree: true
    });
  });
}

/**
 * Load the result of the code execution, either in a split screen or a new window.
 * 
 * @param {string} url the URL to load the result from
 * @param {boolean} newWindow whether to open the result in a new window
 * @param {string} buttonText the text of the button that was clicked
 */
function loadResult(url, newWindow, buttonText) {
  const splitScreenEnabled = $("#split-screen-btn").hasClass("active");

  if (splitScreenEnabled && buttonText === "Run Code") {
    $("#result-frame").attr("src", url);
    $("#result-frame-container").show();
    $(".split-screen-container").addClass("active");

    // Initialize scroll position maintenance after iframe loads
    $("#result-frame").on('load', function () {
      initScrollPositionMaintenance();
    });
  } else {
    $("#result-frame-container").hide();
    $(".split-screen-container").removeClass("active");
    if (newWindow) {
      window.open(url);
    } else {
      isResubmit = true;
      window.location = url;
    }
  }
}

/**
 * Display a onbeforeunload prompt if there are unsaved changes.
 *
 * @param {*} e the event object
 * @returns
 */
function unsavedChangesPromptHandler(e) {
  const confirmationMessage =
    "It looks like you have been editing something. " +
    "If you leave before saving, your changes will be lost.";
  if (!isResubmit) {
    (e || window.event).returnValue = confirmationMessage; //Gecko + IE
    return confirmationMessage; //Gecko + Webkit, Safari, Chrome etc.
  }
}

/**
 * Handle the processing of items injected into the template.
 *
 * Currently, these items are:
 * - buttons-in
 * - files-in
 */
function handleInjectedItems() {
  const buttonsInEnc = $("#injected-buttons-in").html();
  const buttonsIn = JSON.parse(atob(buttonsInEnc));

  for (const [i, button] of buttonsIn.entries()) {
    // Convert to kebab-case
    const newButtonId = button.text.toLowerCase().replace(/\s+/g, "-");

    // Clone the td template
    const newButtonIn = $("#template-button-in")
      .clone()
      .prop("id", "buttonin-" + i);

    // Create button click/touch handler
    const handleAction = async (event) => {
      event.preventDefault();
      event.stopPropagation();

      try {
        const e = {
          text: button.text,
          no_further_query: button.no_further_query,
          post_url: button.post_url,
          split_action_url: button.split_action_url,
          redirect_url: button.redirect_url,
          new_window: button.new_window,
          params: button.params,
        };

        await postCode(e);
      } catch (error) {
        alert(error.message || 'An error occurred while processing your request');
      }

      return false;
    };

    // Set up button
    const buttonElement = newButtonIn
      .children("button")
      .append(button.text)
      .prop("id", newButtonId)
      .addClass(button.class);

    // Handle both touch and click events
    buttonElement[0].addEventListener('touchstart', handleAction, { passive: false });
    buttonElement[0].addEventListener('click', handleAction, { passive: false });

    // Inject into the buttons content section
    $("#content-button-in").append(newButtonIn);
  }

  // files-in: import tabs
  const filesInEnc = $("#injected-files-in").html();
  const filesIn = JSON.parse(atob(filesInEnc));

  for (const file of filesIn) {
    createTab(file.content, file.filename);
  }

  redrawNav();
}

/**
 * Handle the toggling of fullscreen mode for the editor.
 */
function toggleFullscreen() {
  if (!document.fullscreenElement) {
    document.documentElement.requestFullscreen()
      .catch(err => console.log('Error attempting to enable fullscreen:', err));
  } else {
    document.exitFullscreen();
  }
}

/**
 * Change the icon of the fullscreen button depending on the state.
 */
function updateFullscreenButtonIcon() {
  const fullscreenBtn = document.getElementById('fullscreen-btn');
  if (!fullscreenBtn) return;

  if (document.fullscreenElement) {
    fullscreenBtn.innerHTML = '<i class="fas fa-compress"></i>';
    fullscreenBtn.setAttribute('title', 'Exit Fullscreen');
  } else {
    fullscreenBtn.innerHTML = '<i class="fas fa-expand"></i>';
    fullscreenBtn.setAttribute('title', 'Enter Fullscreen');
  }
}

// Event listener for fullscreen changes
document.addEventListener('fullscreenchange', updateFullscreenButtonIcon);

$((/* entrypoint */) => {
  handleInjectedItems();

  window.onbeforeunload = unsavedChangesPromptHandler;

  // Activate action buttons

  // Wrap existing content and add result frame
  $("#content-ide-tabs").wrap('<div class="split-screen-container"></div>');
  $(".split-screen-container").append('<div id="result-frame-container" style="display:none;"><iframe id="result-frame"></iframe></div>');

  initDragResize();

  // Initialize split screen state with button
  const initialSplitScreenState = false; // Start with split screen disabled
  toggleSplitScreen(initialSplitScreenState);

  // Event listener for the fullscreen button
  $("#fullscreen-btn").on("click", toggleFullscreen);

  // Event listener for the split screen button
  $("#split-screen-btn").on("click", function () {
    const isActive = $(this).hasClass("active");
    toggleSplitScreen(!isActive); // Toggle to opposite state
  });

  $(document).ready(function () {
    initScrollPositionMaintenance();
  });

  // Adjust layout on window resize
  $(window).on('resize', function () {
    resizeEditor();
  });
});
