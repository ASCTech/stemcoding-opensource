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
    tabEditor.setShowPrintMargin(false);  
  tabEditor.getSession().setMode("ace/mode/javascript");
  //tabEditor.setTheme("ace/theme/tomorrow"); // Use default theme

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
  const requests = {
    ids: [],
    posts: [],
  };

  for (const ref of tabRefs) {
    requests.posts.push(
      sendCodeToBackend(ref.name, ref.editor.getValue())
        .then((data) => {
          if (data.id !== null) {
            requests.ids.push(data.id);
          }
        })
        .catch((error) => {
          alert(error);
        }),
    );
  }

  $.when.apply(this, requests.posts).done(() => {
    const ids = requests.ids.join("-");
    const params = { ...e.params, ids };

    if (e.no_further_query) {
      const url = e.split_action_url + "?" + $.param(params);

      if (e.new_window) {
        window.open(url);
      } else {
        window.location = url;
      }
    } else {
      $.get(e.split_action_url, params, (data) => {
        const url = e.redirect_url + "?query=" + encodeURIComponent(data.query);

        if (e.new_window) {
          window.open(url);
        } else {
          isResubmit = true;
          window.location = url;
        }
      });
    }
  });
}

/* Runtime */

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

    // Properly set up button
    newButtonIn
      .children("button")
      .append(button.text)
      .prop("id", newButtonId)
      .addClass(button.class)
      .on("click", () => {
        const e = {
          text: button.text,
          no_further_query: button.no_further_query,
          post_url: button.post_url,
          split_action_url: button.split_action_url,
          redirect_url: button.redirect_url,
          new_window: button.new_window,
          params: button.params,
        };

        postCode(e);
      });

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

$((/* entrypoint */) => {
  handleInjectedItems();
});
