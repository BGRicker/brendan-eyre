// Configure your import map in config/importmap.rb

import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import "./controllers"
import "jquery"

// Make jQuery available globally
window.jQuery = jQuery
window.$ = jQuery
