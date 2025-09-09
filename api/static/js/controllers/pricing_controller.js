import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["amount"]

  monthly(event) {
    event.preventDefault()
    
    // Update toggle buttons
    this.element.querySelectorAll('.toggle-option').forEach(option => {
      option.classList.remove('active')
    })
    event.currentTarget.classList.add('active')
    
    // Update prices
    this.element.querySelectorAll('.price-amount').forEach(amount => {
      const monthlyPrice = amount.dataset.monthly
      if (monthlyPrice) {
        amount.textContent = monthlyPrice
      }
    })
    
    // Update period text
    this.element.querySelectorAll('.price-period').forEach(period => {
      period.textContent = '/month'
    })
  }

  yearly(event) {
    event.preventDefault()
    
    // Update toggle buttons
    this.element.querySelectorAll('.toggle-option').forEach(option => {
      option.classList.remove('active')
    })
    event.currentTarget.classList.add('active')
    
    // Update prices
    this.element.querySelectorAll('.price-amount').forEach(amount => {
      const yearlyPrice = amount.dataset.yearly
      if (yearlyPrice) {
        amount.textContent = yearlyPrice
      }
    })
    
    // Update period text
    this.element.querySelectorAll('.price-period').forEach(period => {
      period.textContent = '/month'
    })
  }
}