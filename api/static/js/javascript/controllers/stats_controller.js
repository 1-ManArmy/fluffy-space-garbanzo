import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["section", "number", "card"]
  
  connect() {
    this.setupIntersectionObserver()
    this.animated = false
  }

  setupIntersectionObserver() {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting && !this.animated) {
          this.animateCounters()
          this.animated = true
        }
      })
    }, {
      threshold: 0.3
    })

    if (this.sectionTarget) {
      observer.observe(this.sectionTarget)
    }
  }

  animateCounters() {
    this.numberTargets.forEach((numberEl, index) => {
      const target = parseFloat(numberEl.dataset.target)
      const isDecimal = target.toString().includes('.')
      
      // Stagger the animations with phantom timing
      setTimeout(() => {
        this.countUp(numberEl, target, isDecimal)
      }, index * 400) // Slower, more dramatic timing
    })
  }

  countUp(element, target, isDecimal = false) {
    const duration = 3000 // Slower, more mysterious animation
    const startTime = performance.now()
    const startValue = 0

    const animate = (currentTime) => {
      const elapsed = currentTime - startTime
      const progress = Math.min(elapsed / duration, 1)
      
      // Phantom easing - more dramatic curve
      const easedProgress = progress === 1 ? 1 : 1 - Math.pow(2, -8 * progress)
      
      const currentValue = startValue + (target - startValue) * easedProgress
      
      if (isDecimal) {
        element.textContent = currentValue.toFixed(1)
      } else {
        element.textContent = Math.floor(currentValue).toLocaleString()
      }

      if (progress < 1) {
        requestAnimationFrame(animate)
      } else {
        // Animation complete - add phantom completion effects
        this.onPhantomCountComplete(element)
      }
    }

    requestAnimationFrame(animate)
  }

  onPhantomCountComplete(element) {
    const card = element.closest('.phantom-card')
    
    // Add phantom completion pulse
    card.classList.add('phantom-complete')
    
    // Add ghostly glow effect
    const glow = card.querySelector('.phantom-glow-effect')
    if (glow) {
      glow.style.opacity = '1'
      setTimeout(() => {
        glow.style.opacity = '0'
      }, 2000) // Longer glow duration
    }

    // Remove completion class after animation
    setTimeout(() => {
      card.classList.remove('phantom-complete')
    }, 800)

    // Play eerie completion sound
    this.playPhantomSound()
  }

  playPhantomSound() {
    // Create dark, atmospheric audio feedback
    if (typeof AudioContext !== 'undefined' || typeof webkitAudioContext !== 'undefined') {
      try {
        const audioContext = new (window.AudioContext || window.webkitAudioContext)()
        const oscillator = audioContext.createOscillator()
        const gainNode = audioContext.createGain()
        
        oscillator.connect(gainNode)
        gainNode.connect(audioContext.destination)
        
        // Deep, phantom-like frequency
        oscillator.frequency.setValueAtTime(200, audioContext.currentTime) // Lower, more ominous
        oscillator.type = 'triangle' // Softer, more ethereal
        
        gainNode.gain.setValueAtTime(0, audioContext.currentTime)
        gainNode.gain.linearRampToValueAtTime(0.03, audioContext.currentTime + 0.1) // Quieter
        gainNode.gain.exponentialRampToValueAtTime(0.001, audioContext.currentTime + 1.5) // Longer decay
        
        oscillator.start(audioContext.currentTime)
        oscillator.stop(audioContext.currentTime + 1.5)
      } catch (e) {
        // Silently fail if audio context is not available
      }
    }
  }

  // Enhanced phantom hover effects
  cardTargetConnected(element) {
    element.addEventListener('mousemove', (e) => {
      this.handlePhantomCardHover(e, element)
    })
    
    element.addEventListener('mouseleave', () => {
      this.resetPhantomCardTransform(element)
    })
  }

  handlePhantomCardHover(event, card) {
    const rect = card.getBoundingClientRect()
    const x = event.clientX - rect.left
    const y = event.clientY - rect.top
    
    const centerX = rect.width / 2
    const centerY = rect.height / 2
    
    // More subtle phantom movements
    const rotateX = (y - centerY) / centerY * -3
    const rotateY = (x - centerX) / centerX * 3
    
    const glassElement = card.querySelector('.phantom-glass')
    if (glassElement) {
      glassElement.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateZ(20px)`
    }
  }

  resetPhantomCardTransform(card) {
    const glassElement = card.querySelector('.phantom-glass')
    if (glassElement) {
      glassElement.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg) translateZ(0px)'
    }
  }
}