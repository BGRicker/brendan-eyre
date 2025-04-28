// Import and register all your controllers from the importmap via controllers/**/*_controller
import { Application } from "@hotwired/stimulus"
import HelloController from "./hello_controller"

window.Stimulus = Application.start()
window.Stimulus.register("hello", HelloController)
