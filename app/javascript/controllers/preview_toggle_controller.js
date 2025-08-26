// app/javascript/controllers/preview_toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "previewPane", "codePane" ]

  connect() {
    this.tabs = this.element.querySelectorAll('.tab')
  }

  toggle() {
    this.previewPaneTarget.classList.toggle('hidden')
    this.codePaneTarget.classList.toggle('hidden')
  }
  
  switchTab(event) {
    this.tabs.forEach(tab => tab.classList.remove('tab-active'))
    event.currentTarget.classList.add('tab-active')
  }
}