import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "moveModal", "destinationType", "inboxSection", "boardSection",
    "boardSelect", "listSelect", "boardPositionSelect", "inboxPositionSelect"]
  static values = {
    cardId: Number,
    userId: Number,
    boards: Array
  }

  connect() {
    this.updateDestination()
  }

  openMoveModal(event) {
    event.preventDefault()
    this.moveModalTarget.classList.remove("hidden")
    document.body.style.overflow = "hidden"
  }

  closeMoveModal() {
    this.moveModalTarget.classList.add("hidden")
    document.body.style.overflow = ""
  }

  updateDestination() {
    const destinationType = this.destinationTypeTarget.value
    
    if (destinationType === "inbox") {
      this.inboxSectionTarget.classList.remove("hidden")
      this.boardSectionTarget.classList.add("hidden")
      this.loadInboxPositions()
    } else {
      this.inboxSectionTarget.classList.add("hidden")
      this.boardSectionTarget.classList.remove("hidden")
      this.updateListsForBoard()
    }
  }

  async loadInboxPositions() {
    try {
      const response = await fetch(`/users/${this.userIdValue}/cards_count`)
      const data = await response.json()
      const count = data.count
      
      this.inboxPositionSelectTarget.innerHTML = ""
      for (let i = 1; i <= count + 1; i++) {
        const option = document.createElement("option")
        option.value = i
        option.textContent = i
        this.inboxPositionSelectTarget.appendChild(option)
      }
    } catch (error) {
      console.error("Error loading inbox positions:", error)
    }
  }

  async updateListsForBoard() {
    const boardId = this.boardSelectTarget.value
    
    if (!boardId) {
      this.listSelectTarget.innerHTML = '<option value="">Select a list</option>'
      return
    }

    try {
      const response = await fetch(`/boards/${boardId}/lists.json`)
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      const lists = await response.json()
      
      this.listSelectTarget.innerHTML = '<option value="">Select a list</option>'
      lists.forEach(list => {
        const option = document.createElement("option")
        option.value = list.id
        option.textContent = list.name
        this.listSelectTarget.appendChild(option)
      })
      
      // Clear positions when changing boards
      this.boardPositionSelectTarget.innerHTML = '<option value="">Select a list first</option>'
    } catch (error) {
      console.error("Error loading lists:", error)
      this.listSelectTarget.innerHTML = '<option value="">Error loading lists</option>'
    }
  }

  async updatePositionsForList() {
    const listId = this.listSelectTarget.value
    const boardId = this.boardSelectTarget.value

    if (!listId || !boardId) {
      this.boardPositionSelectTarget.innerHTML = '<option value="">Select a position</option>'
      return
    }

    try {
      const url = `/boards/${boardId}/lists/${listId}/cards_count`
      const response = await fetch(url)
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      const data = await response.json()
      const count = data.count

      this.boardPositionSelectTarget.innerHTML = ""
      for (let i = 1; i <= count + 1; i++) {
        const option = document.createElement("option")
        option.value = i
        option.textContent = i
        this.boardPositionSelectTarget.appendChild(option)
      }

    } catch (error) {
      console.error("Error loading positions:", error)
      this.boardPositionSelectTarget.innerHTML = '<option value="">Error loading positions</option>'
    }
  }

  async moveCard(event) {
    event.preventDefault()

    const destinationType = this.destinationTypeTarget.value
    let position

    if (destinationType === "inbox") {
      position = this.inboxPositionSelectTarget.value
    } else {
      position = this.boardPositionSelectTarget.value
    }

    if (!position) {
      alert("Please select a position")
      return
    }

    let url, body

    if (destinationType === "inbox") {
      url = `/cards/${this.cardIdValue}/move`
      body = {
        user_id: this.userIdValue,
        position: parseInt(position) - 1
      }
    } else {
      const boardId = this.boardSelectTarget.value
      const listId = this.listSelectTarget.value

      if (!boardId || !listId) {
        alert("Please select a board and list")
        return
      }

      url = `/boards/${boardId}/lists/${listId}/cards/${this.cardIdValue}/move`
      body = {
        list_id: listId,
        position: parseInt(position) - 1
      }
    }

    try {
      const response = await fetch(url, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify(body)
      })

      if (response.ok) {
        this.closeMoveModal()
        window.location.reload()
      } else {
        alert("Failed to move card")
      }
    } catch (error) {
      console.error("Error moving card:", error)
      alert("Error moving card")
    }
  }
}
