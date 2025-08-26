// app/javascript/controllers/generation_status_controller.js
import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

export default class extends Controller {
  static values = { url: String, errorUrl: String }
  static targets = [ "message" ]

  connect() {
    this.updateMessage("Preparing your request...");
    this.startGeneration();
  }

  async startGeneration() {
    // A small delay to let the user see the initial message
    await this.sleep(1000);
    this.updateMessage("Contacting our AI web developer...");

    // Fake progress updater
    this.progressInterval = setInterval(() => {
        const messages = [
            "Designing the layout...",
            "Writing the HTML for the homepage...",
            "Styling with modern CSS...",
            "Creating the about page...",
            "Generating content for your services...",
            "Building the contact form...",
            "Finalizing the website files..."
        ];
        const randomMessage = messages[Math.floor(Math.random() * messages.length)];
        this.updateMessage(randomMessage);
    }, 4000);

    const response = await post(this.urlValue, { responseKind: "json" })

    clearInterval(this.progressInterval);

    if (response.ok) {
      const { redirect_url } = await response.json
      this.updateMessage("Website generated successfully! Redirecting...");
      window.location.href = redirect_url;
    } else {
      const { error } = await response.json
      this.updateMessage(`An error occurred: ${error}. Redirecting...`);
      await this.sleep(3000);
      window.location.href = this.errorUrlValue;
    }
  }

  disconnect() {
    if (this.progressInterval) {
      clearInterval(this.progressInterval);
    }
  }

  updateMessage(text) {
    this.messageTarget.textContent = text;
  }

  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}