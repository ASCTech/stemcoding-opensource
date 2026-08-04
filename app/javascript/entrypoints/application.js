// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>
console.log("Vite ⚡️ Rails");

// If using a TypeScript entrypoint file:
//     <%= vite_typescript_tag 'application' %>
//
// If you want to use .jsx or .tsx, add the extension:
//     <%= vite_javascript_tag 'application.jsx' %>

console.log(
  "Visit the guide for more information: ",
  "https://vite-ruby.netlify.app/guide/rails",
);

// Load Rails libraries in Vite.
//
// import * as Turbo from '@hotwired/turbo'
// Turbo.start()
//
import Ujs from "@rails/ujs";
Ujs.start();

import * as Activestorage from "@rails/activestorage";
Activestorage.start();

// import channels
import.meta.glob("../channels/**/**.js");

// import jQuery
import $ from "jquery";

// import Bootstrap and Cocoon
import "bootstrap/dist/js/bootstrap.bundle.min";
import "../vendor/cocoon";

// import stylesheets
import "../stylesheets/application.scss";
import "prismjs/themes/prism.css";

// import stimulus controllers
import "@/controllers"

// Ace editor
import ace from "brace";
import "brace/mode/javascript"
// import "brace/theme/tomorrow"; // Use default theme
// import "brace/theme/gruvbox";

// // Import TinyMCE
// import * as tinymce from "tinymce/tinymce";

// // Import TinyMCE theme
// import "tinymce/themes/silver/theme";

// // Import TinyMCE plugins
// import "tinymce/plugins/code";
// import "tinymce/plugins/codesample";
// import "tinymce/plugins/image";
// import "tinymce/plugins/link";
// import "tinymce/plugins/media";
// import "tinymce/icons/default";


// // Initialize tinymce w/ theme and plugins
// tinymce.init({
//   selector: ".tinymce",
//   toolbar:
//     "styleselect codesample | bold italic | superscript subscript | undo redo | image media | link | code",
//   plugins: ["code", "codesample", "image", "link", "media"],
//   codesample_languages: [
//     { text: "JavaScript", value: "javascript" },
//     { text: "HTML/XML", value: "markup" },
//   ],
// });

import "prismjs/prism";
import ClipboardJS from "clipboard";

$(function() {
  var clipboard = new ClipboardJS(".clipboard");
  var copyButton = $("template#copy-button").html();
  var $copyButton = $(copyButton);
  // $copyButton.popover();

  // adds a copy code button to each code snippet
  $("pre.language-javascript").each(function (index) {
    $(this).css("position", "relative");
    var code = $(this).text();
    $copyButton.attr("data-clipboard-text", code);
    $(this).prepend($copyButton.clone(true));
  });
});

// Converts server time to client time
import LocalTime from "local-time";
LocalTime.start();
