class WebsiteRequestsController < ApplicationController
  def new
    @website_request = WebsiteRequest.new
  end

  def create
    @website_request = WebsiteRequest.new
    @website_request.save(validate: false)
    redirect_to website_request_step_path(@website_request, :business_type)
  end

  def generating
    @website_request = WebsiteRequest.find(params[:id])
  end

  def perform_generation
    @website_request = WebsiteRequest.find(params[:id])
    generated_path = AiWebsiteGenerator.new(@website_request).call

    if generated_path
      @website_request.update(generated_path: generated_path)
      if @website_request.email.present?
        WebsiteMailer.with(website_request: @website_request).generation_complete.deliver_later
      end
      render json: { success: true, redirect_url: preview_site_path(@website_request) }
    else
      render json: { success: false, redirect_url: root_path, error: "There was an error generating your website." }, status: :internal_server_error
    end
  end

  def deploy
    @website_request = WebsiteRequest.find(params[:id])
    # Mock deployment by updating the record
    @website_request.update(
      deployed_at: Time.current,
      repo_url: "https://github.com/mock-user/#{@website_request.business_name.parameterize}"
    )

    # Send deployment complete email
    WebsiteMailer.with(website_request: @website_request).deployment_complete.deliver_later

    redirect_to preview_site_path(@website_request), notice: "Deployment successful! A confirmation email has been sent."
  end

  # GET /website_requests/:id/download
  # Zips the generated site directory and sends it as a download
  def download
    @website_request = WebsiteRequest.find(params[:id])
    base_dir = @website_request.generated_path

    unless base_dir.present? && Dir.exist?(base_dir)
      return redirect_to preview_site_path(@website_request), alert: "Generated site not found."
    end

    # Build a zip filename
    safe_name = @website_request.business_name.present? ? @website_request.business_name.parameterize : "site"
    zip_filename = "#{safe_name}-#{@website_request.id}.zip"

    # Prepare output path under tmp/downloads
    require 'securerandom'
    downloads_dir = Rails.root.join('tmp', 'downloads')
    FileUtils.mkdir_p(downloads_dir) unless Dir.exist?(downloads_dir)
    out_path = downloads_dir.join("#{SecureRandom.hex(8)}-#{zip_filename}")

    zipped = false
    begin
      system("zip", "-r", "-q", out_path.to_s, ".", chdir: base_dir)
      zipped = File.exist?(out_path) && File.size(out_path).to_i > 0
    rescue => _e
      zipped = false
    end

    unless zipped
      begin
        require 'zip'
        ::Zip::File.open(out_path.to_s, ::Zip::File::CREATE) do |zipfile|
          Dir[File.join(base_dir, '**', '*')].each do |file|
            next if File.directory?(file)
            entry_name = file.delete_prefix(File.join(base_dir, File::SEPARATOR))
            zipfile.add(entry_name, file)
          end
        end
        zipped = true
      rescue LoadError
        return redirect_to preview_site_path(@website_request), alert: "Zip support is unavailable on this server."
      end
    end

    # async cleanup: delete the file shortly after response is sent
    Thread.new(out_path.to_s) do |path|
      begin
        sleep 60
        File.delete(path) if File.exist?(path)
      rescue StandardError
        # ignore cleanup errors
      end
    end

    send_file out_path, filename: zip_filename, type: 'application/zip', disposition: 'attachment'
  end

end
