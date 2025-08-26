require "agents"
require "httparty"
class ImageTool < Agents::Tool
  description "A tool for generating image URLs from a text prompt using OpenAI's Images API. Supported sizes: 256x256, 512x512, 1024x1024."

  param :prompt, type: "string", desc: "The prompt to generate the image."
  param :size, type: "string", desc: "The size of the generated image. Options are '256x256', '512x512', and '1024x1024'. Default is '1024x1024'."

  def generate_image(prompt, size)
    api_key = ENV['OPENAI_API_KEY']
    raise "Missing OPENAI_API_KEY" if api_key.nil? || api_key.strip.empty?

    allowed_sizes = ["256x256", "512x512", "1024x1024"]
    size = allowed_sizes.include?(size) ? size : "1024x1024"

    headers = { 'Authorization' => "Bearer #{api_key}", 'Content-Type' => 'application/json' }
    body = { prompt: prompt, n: 1, size: size }.to_json

    HTTParty.post(
      'https://api.openai.com/v1/images/generations',
      headers: headers,
      body: body
    )
  end

  def perform(tool_context, prompt:, size: "1024x1024")
    begin
      response = generate_image(prompt, size)
      if response.success?
        data = response.parsed_response
        image_url = data && data["data"] && data["data"][0] && data["data"][0]["url"]
        image_url || { error: "No image URL in response" }
      else
        err = (response.parsed_response && response.parsed_response.dig("error", "message")) || "Unknown error"
        { error: err }
      end
    rescue => e
      { error: "Error generating image: #{e.message}" }
    end
  end

end


