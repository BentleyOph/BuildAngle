require "httparty"
require "uri"

# Handles communication with the Unsplash API
# Supports both OAuth bearer token and Client-ID authentication
class UnsplashApi
  BASE_URL = "https://api.unsplash.com".freeze

  def initialize
    @headers = build_headers!
  end

  # Search for photos using the /search/photos endpoint
  def search_photos(query:, orientation: nil, per_page: 1)
    params = { query: query, per_page: per_page }
    params[:orientation] = normalize_orientation(orientation) if orientation

    HTTParty.get(
      "#{BASE_URL}/search/photos",
      headers: @headers,
      query: params
    )
  end

  # Get random photos using the /photos/random endpoint
  def random_photos(query:, orientation: nil, count: 1)
    params = { query: query, count: count }
    params[:orientation] = normalize_orientation(orientation) if orientation

    HTTParty.get(
      "#{BASE_URL}/photos/random",
      headers: @headers,
      query: params
    )
  end

  # Extract the first photo from search results
  def extract_first_search_result(response)
    return nil unless response.success?
    
    body = response.parsed_response
    return nil unless body.is_a?(Hash)
    
    results = body["results"]
    return nil unless results.is_a?(Array) && results.first
    
    results.first
  end

  # Extract photo from random response
  def extract_random_photo(response)
    return nil unless response.success?
    
    parsed = response.parsed_response
    Array(parsed).first || parsed
  end

  # Generate error message from API responses
  def extract_error_message(*responses)
    resp = responses.compact.find { |r| r && !r.success? }
    if resp && resp.parsed_response
      parsed = resp.parsed_response
      if parsed.is_a?(Hash)
        return parsed["errors"]&.join(", ") || parsed["error_description"] || parsed["error"] || "Unknown Unsplash API error"
      end
    end
    "Unknown Unsplash API error"
  end

  private

  def build_headers!
    if (token = ENV["UNSPLASH_ACCESS_TOKEN"]) && !token.strip.empty?
      { "Authorization" => "Bearer #{token}" }
    elsif (key = ENV["UNSPLASH_ACCESS_KEY"]) && !key.strip.empty?
      { "Authorization" => "Client-ID #{key}" }
    else
      raise "Missing Unsplash credentials. Set UNSPLASH_ACCESS_TOKEN or UNSPLASH_ACCESS_KEY."
    end
  end

  def normalize_orientation(orientation)
    return nil unless orientation
    
    normalized = orientation.to_s.downcase
    %w[landscape portrait squarish].include?(normalized) ? normalized : nil
  end
end
