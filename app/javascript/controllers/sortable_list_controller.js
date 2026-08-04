import { Controller } from "@hotwired/stimulus";
import { Sortable as SortJS } from 'sortablejs';

export default class extends Controller {
  static targets = [ "submit",  "position" ]

  connect() {
    const container = this.element.querySelector(this.data.get("container")) || this.element;
    const draggableSelector = this.data.get("draggable-selector") || ".draggable-source";
    const dragHandle = this.data.get("drag-handle");

    this.resetPositionTargets();

    new SortJS(container, {
      sort: true,
      handle: dragHandle,
      draggable: draggableSelector,
      onEnd: ((evt) => {
        this.resetPositionTargets();
        this.submitTarget.click();
      }).bind(this)
    });
  }

  resetPositionTargets() {
    var position = 1;
    this.positionTargets.forEach(positionTarget => {
      positionTarget.value = position++;
    });
  }
}
