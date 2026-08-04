// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "@hotwired/stimulus";

// require('brace');
// require('brace/theme/tomorrow');
// require('brace/mode/javascript');
import "brace";
// import "brace/theme/tomorrow"; // Use default theme
import "brace/mode/javascript";

export default class extends Controller {
  static targets = [ "content" ]

  connect() {
    this.contentTargets.forEach(target => {
      var code = ace.edit(target.getAttribute("id"));
      code.getSession().setMode('ace/mode/javascript');
      // code.setTheme('ace/theme/tomorrow'); // Use default theme
      code.setOptions({maxLines: 100, minLines: 25});
    });
  }
}
