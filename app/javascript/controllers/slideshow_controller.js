import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "slide" ]

  initialize() {
    this.showCurrentSlide()
  }

  next() {
    this.index += 1
  }

  previous() {
    this.index -= 1
  }

  showCurrentSlide() {
    console.log(`showCurrentSlide(): ${this.index}`)
    this.slideTargets.forEach((el, i) => {
      el.classList.toggle("slide--current", this.index === i)
    })
  }

  get index() {
    const index = Number(this.data.get('index'))
    return index !== index ? 0 : index
  }

  set index(value) {
    if (value < 0) {
      value = this.slideTargets.length - 1
    } else if (value > this.slideTargets.length - 1) {
      value = 0
    }
    this.data.set('index', value)
    this.showCurrentSlide()
  }
}
