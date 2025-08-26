require "agents"
require "uri"
require_relative "unsplash_api"

class UnsplashImage < Agents::Tool
  description "Searches Unsplash and returns a direct image URL. Supports optional orientation (landscape, portrait, squarish) and size like '1024x768' to crop via Imgix params."

  param :query, type: "string", desc: "Search keywords for the photo (e.g., 'modern tech startup office')."
  param :orientation, type: "string", desc: "Photo orientation: 'landscape', 'portrait', or 'squarish'. Optional.", required: false
  param :size, type: "string", desc: "Optional WxH crop, e.g. '1600x900' or '800x600'.", required: false

  def initialize
    super
    @api = UnsplashApi.new
  end

  def perform(_tool_context, query:, orientation: nil, size: nil)
    # 1) Try search/photos for deterministic results
    search_resp = @api.search_photos(query: query, orientation: orientation)
    
    if (photo = @api.extract_first_search_result(search_resp))
      return build_image_url(photo, size)
    end

    # 2) Fallback to photos/random
    random_resp = @api.random_photos(query: query, orientation: orientation)
    
    if (photo = @api.extract_random_photo(random_resp))
      return build_image_url(photo, size)
    end

    { error: @api.extract_error_message(search_resp, random_resp) }
  rescue => e
    { error: "Unsplash error: #{e.message}" }
  end

  private

  # Prefer the "regular" URL for embeds; apply optional WxH via Imgix params
  def build_image_url(photo_obj, size)
    return { error: "Malformed Unsplash response" } unless photo_obj.is_a?(Hash)
    urls = photo_obj["urls"] || {}
    base = urls["regular"] || urls["full"] || urls["raw"]
    return { error: "No image URL returned" } unless base

    return base unless size && size =~ /\A\d+x\d+\z/

    w, h = size.split("x").map(&:to_i)
    uri = URI(base)
    q = URI.decode_www_form(uri.query.to_s)
    q << ["auto", "format"]
    q << ["fit", "crop"]
    q << ["w", w.to_s]
    q << ["h", h.to_s]
    uri.query = URI.encode_www_form(q)
    uri.to_s
  end
end
