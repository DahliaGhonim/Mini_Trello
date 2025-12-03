import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.body.style.overflow = "hidden"
  }

  disconnect() {
    document.body.style.overflow = ""
  }

  close(event) {
    if (event.target === event.currentTarget || event.currentTarget.dataset.action === "click->modal#close") {
      this.element.remove()
    }
  }

  closeWithKeyboard(event) {
    if (event.key === "Escape") {
      this.element.remove()
    }
  }
}
