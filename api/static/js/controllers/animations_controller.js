import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="animations"
export default class extends Controller {
  static targets = ["container"]

  connect() {
    console.log("Animations controller connected")
    this.initializeAnimations()
  }

  initializeAnimations() {
    // Smooth scroll behavior for anchor links
    this.element.addEventListener('click', (e) => {
      if (e.target.tagName === 'A' && e.target.getAttribute('href')?.startsWith('#')) {
        e.preventDefault()
        const targetId = e.target.getAttribute('href').substring(1)
        const targetElement = document.getElementById(targetId)
        if (targetElement) {
          targetElement.scrollIntoView({ behavior: 'smooth' })
        }
      }
    })

    // Intersection Observer for scroll animations
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px'
    }

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-fade-in')
        }
      })
    }, observerOptions)

    // Observe elements that should animate on scroll
    const animateElements = document.querySelectorAll('.feature-card, .glass-card')
    animateElements.forEach(el => observer.observe(el))

    // Terminal typing animation
    this.startTerminalAnimation()
  }

  startTerminalAnimation() {
    const terminalLines = document.querySelectorAll('.terminal-content > div')
    
    terminalLines.forEach((line, index) => {
      // Add typing effect to lines with delay
      setTimeout(() => {
        line.style.opacity = '0'
        line.style.transform = 'translateX(-10px)'
        line.style.transition = 'all 0.3s ease'
        
        setTimeout(() => {
          line.style.opacity = '1'
          line.style.transform = 'translateX(0)'
        }, 100)
      }, index * 500)
    })
  }

  // Button hover effects
  enhanceButtonHovers() {
    const buttons = document.querySelectorAll('.btn-primary, .btn-secondary')
    
    buttons.forEach(button => {
      button.addEventListener('mouseenter', () => {
        button.style.transform = 'scale(1.05) translateY(-2px)'
      })
      
      button.addEventListener('mouseleave', () => {
        button.style.transform = 'scale(1) translateY(0)'
      })
    })
  }
}