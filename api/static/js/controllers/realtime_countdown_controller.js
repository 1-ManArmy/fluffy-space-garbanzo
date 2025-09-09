import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["days", "hours", "minutes", "seconds"]
  static values = { targetDate: String }

  connect() {
    console.log("Real-time countdown controller connected")
    this.startCountdown()
  }

  disconnect() {
    if (this.countdownInterval) {
      clearInterval(this.countdownInterval)
    }
  }

  startCountdown() {
    // Set target date - you can customize this
    const targetDate = this.targetDateValue || "2025-12-31T23:59:59Z"
    this.endTime = new Date(targetDate).getTime()
    
    // Update immediately
    this.updateCountdown()
    
    // Update every second
    this.countdownInterval = setInterval(() => {
      this.updateCountdown()
    }, 1000)
  }

  updateCountdown() {
    const now = new Date().getTime()
    const distance = this.endTime - now

    if (distance < 0) {
      this.handleExpired()
      return
    }

    // Calculate time units
    const days = Math.floor(distance / (1000 * 60 * 60 * 24))
    const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60))
    const seconds = Math.floor((distance % (1000 * 60)) / 1000)

    // Update display with animated transitions
    this.updateDigits(this.daysTarget, days)
    this.updateDigits(this.hoursTarget, hours)
    this.updateDigits(this.minutesTarget, minutes)
    this.updateDigits(this.secondsTarget, seconds)
  }

  updateDigits(target, value) {
    if (!target) return
    
    const formattedValue = value.toString().padStart(2, '0')
    const tensDigit = formattedValue[0]
    const onesDigit = formattedValue[1]
    
    // Get individual digit elements
    const tensElement = target.querySelector('.quantum-digit:first-child')
    const onesElement = target.querySelector('.quantum-digit:last-child')
    
    if (tensElement && tensElement.textContent !== tensDigit) {
      this.animateDigitChange(tensElement, tensDigit)
    }
    
    if (onesElement && onesElement.textContent !== onesDigit) {
      this.animateDigitChange(onesElement, onesDigit)
    }
  }

  animateDigitChange(element, newDigit) {
    // Add flip animation class
    element.style.transform = 'rotateX(90deg)'
    element.style.transition = 'transform 0.3s ease'
    
    setTimeout(() => {
      element.textContent = newDigit
      element.style.transform = 'rotateX(0deg)'
      
      // Add quantum glow effect on change
      element.style.textShadow = '0 0 20px rgba(6, 182, 212, 1)'
      
      setTimeout(() => {
        element.style.textShadow = ''
        element.style.transition = ''
      }, 300)
    }, 150)
  }

  handleExpired() {
    if (this.countdownInterval) {
      clearInterval(this.countdownInterval)
    }
    
    // Show expired state
    this.updateDigits(this.daysTarget, 0)
    this.updateDigits(this.hoursTarget, 0)
    this.updateDigits(this.minutesTarget, 0)
    this.updateDigits(this.secondsTarget, 0)
    
    // Add expired styling
    this.element.classList.add('quantum-countdown-expired')
    
    // Dispatch custom event
    this.element.dispatchEvent(new CustomEvent('countdown:expired', {
      bubbles: true,
      detail: { message: 'Countdown has expired!' }
    }))
  }

  // Method to update target date dynamically
  updateTargetDate(newDate) {
    this.targetDateValue = newDate
    this.endTime = new Date(newDate).getTime()
  }

  // Method to add time to countdown
  addTime(milliseconds) {
    this.endTime += milliseconds
  }

  // Get remaining time in milliseconds
  getRemainingTime() {
    const now = new Date().getTime()
    return Math.max(0, this.endTime - now)
  }
}