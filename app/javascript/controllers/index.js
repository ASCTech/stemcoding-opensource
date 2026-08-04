// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { registerControllers } from "stimulus-vite-helpers"
import { Application } from "@hotwired/stimulus"

const application = Application.start()
const controllers = import.meta.glob("./**/*_controller.{js,ts}", {eager: true})
registerControllers(application, controllers)
