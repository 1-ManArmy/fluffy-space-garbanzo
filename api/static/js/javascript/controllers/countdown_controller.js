import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.updateCountdown()
    this.countdownInterval = setInterval(() => {
      this.updateCountdown()
    }, 1000)
  }

  disconnect() {
    if (this.countdownInterval) {
      clearInterval(this.countdownInterval)
    }
  }

  updateCountdown() {
    // Set target date (30 days from now for demo)
    const targetDate = new Date()
    targetDate.setDate(targetDate.getDate() + 30)
    
    const now = new Date()
    const difference = targetDate - now

    if (difference > 0) {
      const days = Math.floor(difference / (1000 * 60 * 60 * 24))
      const hours = Math.floor((difference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
      const minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60))
      const seconds = Math.floor((difference % (1000 * 60)) / 1000)

      this.updateCountdownDisplay(days, hours, minutes, seconds)
    } else {
      this.updateCountdownDisplay(0, 0, 0, 0)
    }
  }

  updateCountdownDisplay(days, hours, minutes, seconds) {
    const items = this.element.querySelectorAll('.countdown-item')
    
    if (items[0]) {
      const daysElement = items[0].querySelector('.countdown-number')
      if (daysElement) daysElement.textContent = days.toString().padStart(2, '0')
    }
    
    if (items[1]) {
      const hoursElement = items[1].querySelector('.countdown-number')
      if (hoursElement) hoursElement.textContent = hours.toString().padStart(2, '0')
    }
    
    if (items[2]) {
      const minutesElement = items[2].querySelector('.countdown-number')
      if (minutesElement) minutesElement.textContent = minutes.toString().padStart(2, '0')
    }
  }
}