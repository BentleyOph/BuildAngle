class WebsiteMailer < ApplicationMailer
  default from: "notifications@buildangle.com"

  # Sends an email when the website generation is complete.
  def generation_complete
    @website_request = params[:website_request]
    @preview_url = preview_site_url(@website_request)
    mail(to: @website_request.email, subject: "Your website for '#{@website_request.business_name}' is ready!")
  end

  # Sends an email after the "deployment" is simulated.
  def deployment_complete
    @website_request = params[:website_request]
    @repo_url = @website_request.repo_url
    @preview_url = preview_site_url(@website_request)
    mail(to: @website_request.email, subject: "Deployment confirmation for '#{@website_request.business_name}'")
  end
end