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
    const newPosition = event.newIndex
    const newListId = event.to.dataset.listId
    const newUserId = event.to.dataset.userId
    const boardId = event.to.dataset.boardId

    let url
    let body
    
    if (newListId && boardId) {
      url = `/boards/${boardId}/lists/${newListId}/cards/${cardId}/move`
      body = {
        list_id: newListId,
        position: newPosition
      }
    } else if (newUserId) {
      url = `/cards/${cardId}/move`
      body = {
        user_id: newUserId,
        position: newPosition
      }
    } else {
      console.error("Unable to determine destination for card move")
      return
    }
    
    try {
      await patch(url, {
        body: JSON.stringify(body),
        contentType: "application/json",
        responseKind: "json"
      })
    } catch (error) {
      console.error("Error moving card:", error)
    }
  }
}
