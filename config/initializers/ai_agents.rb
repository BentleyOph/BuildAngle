require "agents"
Agents.configure do |config|
  config.gemini_api_key = Rails.application.credentials.dig(:gemini_api_key) || ENV['GEMINI_API_KEY']
  config.default_model = 'gemini-2.0-flash'
  config.debug = Rails.env.development?
end
