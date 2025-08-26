class PreviewsController < ApplicationController
  skip_forgery_protection only: :serve_page
  # The frame action serves the page with navigation and the iframe
  def frame
    @website_request = WebsiteRequest.find(params[:id])
    base_dir = @website_request.generated_path
    if base_dir.present? && Dir.exist?(base_dir)
      # List top-level HTML files to drive the nav, fallback to defaults if none
      html_files = Dir.glob(File.join(base_dir, '*.html')).map { |f| File.basename(f) }
      @pages = html_files.presence || ['index.html']
    else
      @pages = ['index.html']
    end
  end

  # This new action will read and render the file content
  def serve_page
    @website_request = WebsiteRequest.find(params[:id])
    base_dir = @website_request.generated_path

    unless base_dir.present? && File.directory?(base_dir)
      return render plain: 'Generated site not found', status: :not_found
    end

    requested = params[:page].to_s
    requested = 'index' if requested.blank?

    # If no extension was provided, try to use the requested format (css/js/png, etc.)
    # Otherwise default to .html
    if File.extname(requested).present?
      rel_path = requested
    elsif params[:format].present?
      rel_path = "#{requested}.#{params[:format]}"
    else
      rel_path = "#{requested}.html"
    end

    # Build absolute path and ensure it stays within base_dir (avoid traversal)
    abs_base = File.expand_path(base_dir) + File::SEPARATOR
    abs_path = File.expand_path(File.join(base_dir, rel_path))
    unless abs_path.start_with?(abs_base)
      return render plain: 'Invalid path', status: :forbidden
    end

    # Allow directory paths to resolve to index.html
    if File.directory?(abs_path)
      abs_path = File.join(abs_path, 'index.html')
    end

    unless File.exist?(abs_path)
      return render plain: 'Page not found', status: :not_found
    end

    # Determine content type based on extension
    ext = File.extname(abs_path)
    content_type = Rack::Mime.mime_type(ext, 'text/plain')

    send_file abs_path, type: content_type, disposition: 'inline'
  end
end