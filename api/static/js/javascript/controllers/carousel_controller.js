import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.currentIndex = 0
    this.startAutoSlide()
  }

  disconnect() {
    this.stopAutoSlide()
  }

  startAutoSlide() {
    this.slideInterval = setInterval(() => {
      this.nextSlide()
    }, 5000)
  }

  stopAutoSlide() {
    if (this.slideInterval) {
      clearInterval(this.slideInterval)
    }
  }

  nextSlide() {
    const cards = this.element.querySelectorAll('.testimonial-crystal-card')
    if (cards.length === 0) return

    this.currentIndex = (this.currentIndex + 1) % cards.length
    this.updateSlidePosition()
  }

  previousSlide() {
    const cards = this.element.querySelectorAll('.testimonial-crystal-card')
    if (cards.length === 0) return

    this.currentIndex = this.currentIndex === 0 ? cards.length - 1 : this.currentIndex - 1
    this.updateSlidePosition()
  }

  updateSlidePosition() {
    const container = this.element.querySelector('.testimonial-container')
    if (container) {
      const translateX = -this.currentIndex * 100
      container.style.transform = `translateX(${translateX}%)`
    }
  }
}