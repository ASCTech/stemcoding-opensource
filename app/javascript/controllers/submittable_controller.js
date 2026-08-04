import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "checkbox", "badge" ]

  connect() {
    const inputName = this.checkboxTarget.getAttribute("name");
    var hiddenInput = this.element.querySelector(`input[name='${inputName}'][type='hidden']`);

    if(this.data.get("enabled") == "true") {
      hiddenInput.value = "1";
      this.checkboxTarget.value = 1;
    } else {
      hiddenInput.value = "0";
      this.checkboxTarget.value = 0;
    }
  }

  toggle(event) {
    const inputName = this.checkboxTarget.getAttribute("name");
    var hiddenInput = this.element.querySelector(`input[name='${inputName}'][type='hidden']`);

    if(this.data.get("enabled") == "true") {
      this.data.set("enabled", false);
      hiddenInput.value = "0";
      this.checkboxTarget.value = "0";

      this.badgeTarget.classList.replace("text-bg-success", "text-bg-warning");
      this.badgeTarget.innerHTML = "Submissions prohibited";
    } else {
      this.data.set("enabled", true);
      hiddenInput.value = "1";
      this.checkboxTarget.value = "1";

      this.badgeTarget.classList.replace("text-bg-warning", "text-bg-success");
      this.badgeTarget.innerHTML = "Submissions allowed";
    }

    this.element.submit();
  }
}
