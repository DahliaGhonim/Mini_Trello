import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import { patch } from "@rails/request.js"

export default class extends Controller {
  static values = {
    group: String,
    animation: { type: Number, default: 150 }
  }

  connect() {
    this.sortable = Sortable.create(this.element, {
      group: this.groupValue,
      animation: this.animationValue,
      onEnd: this.onEnd.bind(this)
    })
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy()
    }
  }

  async onEnd(event) {
    const cardId = event.item.dataset.cardId
    const newListId = event.to.dataset.listId
    const boardId = event.to.dataset.boardId
    const newPosition = event.newIndex

    const url = `/boards/${boardId}/lists/${newListId}/cards/${cardId}/move`

    try {
      await patch(url, {
        body: JSON.stringify({
          list_id: newListId,
          position: newPosition
        }),
        contentType: "application/json",
        responseKind: "json"
      })
    } catch (error) {
      console.error("Error moving card:", error)
    }
  }
}
