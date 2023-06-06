import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "user", "role", "output" ]

  async toggle() {
    const id = this.roleTarget.value
    const url = `/toggle_admin/${id}`
    await fetch(url)
  }
}
