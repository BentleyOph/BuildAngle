class WebsiteRequestStepsController < ApplicationController
  include Wicked::Wizard

  steps :business_type, :design_preferences, :target_audience

  def show
    @website_request = WebsiteRequest.find(params[:website_request_id])
    render_wizard
  end

  def update
    @website_request = WebsiteRequest.find(params[:website_request_id])
    @website_request.update(website_request_params)

    if step == steps.last
      redirect_to generating_website_request_path(@website_request)
    else
      render_wizard @website_request
    end
  end

  private

  def website_request_params
    params.require(:website_request).permit(
      :business_name,
      :business_type,
      :design_preferences,
      :target_audience,
      :style_preferences,
      :color_preferences,
      :inspiration_websites,
      :email
    )
  end
end
