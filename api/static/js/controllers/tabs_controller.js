import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  switch(event) {
    event.preventDefault()
    
    const clickedTab = event.currentTarget
    const targetTab = clickedTab.dataset.tab
    
    // Remove active class from all tabs
    this.element.querySelectorAll('.tab-button').forEach(tab => {
      tab.classList.remove('active')
    })
    
    // Add active class to clicked tab
    clickedTab.classList.add('active')
    
    // Hide all tab contents
    this.element.querySelectorAll('.tab-content').forEach(content => {
      content.classList.remove('active')
    })
    
    // Show target tab content
    const targetContent = this.element.querySelector(`#${targetTab}`)
    if (targetContent) {
      targetContent.classList.add('active')
    }
  }
}