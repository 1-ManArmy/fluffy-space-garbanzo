import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "emailForm", "emailInput", "submitButton", "buttonText", "buttonSpinner", "statusContainer", "successMessage", "errorMessage"]

  connect() {
    console.log("Newsletter controller connected")
  }

  async submitEmail(event) {
    event.preventDefault()
    
    const email = this.emailInputTarget.value.trim()
    
    if (!email) {
      this.showError("Please enter a valid email address")
      return
    }

    if (!this.isValidEmail(email)) {
      this.showError("Please enter a valid email address")
      return
    }

    // Show loading state
    this.setLoadingState(true)
    this.hideAllMessages()

    try {
      const formData = new FormData(this.emailFormTarget)
      
      const response = await fetch('/newsletter', {
        method: 'POST',
        body: formData,
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        }
      })

      const result = await response.json()

      if (response.ok && result.success) {
        this.showSuccess("Successfully subscribed! Your email has been sent to mail@onelastai.com for processing.")
        this.emailInputTarget.value = ""
      } else {
        this.showError(result.error || "Something went wrong. Please try again.")
      }
    } catch (error) {
      console.error("Newsletter subscription error:", error)
      this.showError("Network error. Please check your connection and try again.")
    } finally {
      this.setLoadingState(false)
    }
  }

  setLoadingState(loading) {
    this.submitButtonTarget.disabled = loading
    
    if (loading) {
      this.buttonTextTarget.classList.add("hidden")
      this.buttonSpinnerTarget.classList.remove("hidden")
    } else {
      this.buttonTextTarget.classList.remove("hidden")
      this.buttonSpinnerTarget.classList.add("hidden")
    }
  }

  showSuccess(message) {
    this.hideAllMessages()
    this.successMessageTarget.querySelector("span").textContent = message
    this.successMessageTarget.classList.remove("hidden")
    
    // Auto-hide after 8 seconds
    setTimeout(() => {
      this.successMessageTarget.classList.add("hidden")
    }, 8000)
  }

  showError(message) {
    this.hideAllMessages()
    this.errorMessageTarget.querySelector("span").textContent = message
    this.errorMessageTarget.classList.remove("hidden")
    
    // Auto-hide after 6 seconds
    setTimeout(() => {
      this.errorMessageTarget.classList.add("hidden")
    }, 6000)
  }

  hideAllMessages() {
    this.successMessageTarget.classList.add("hidden")
    this.errorMessageTarget.classList.add("hidden")
  }

  isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }
}