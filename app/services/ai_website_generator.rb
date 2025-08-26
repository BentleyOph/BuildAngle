require "agents"
class AiWebsiteGenerator
  def initialize(website_request)
    @website_request = website_request
    @runner = Agents::Runner.with_agents(CreatorAgent.create_unsplash)
  end

  def call
    timestamp = Time.now.to_i
    user_identifier = "user_#{@website_request.id}" 
    website_name = @website_request.business_name.parameterize
    directory_path = Rails.root.join('public', 'generated_sites', "#{user_identifier}-#{website_name}-#{timestamp}")

    initial_prompt = <<~PROMPT
      Please generate a new website with the following details.
      The root directory for all files MUST be: '#{directory_path}'

      **User Requirements:**
      - **Business Name:** #{@website_request.business_name}
      - **Business Type & Goals:** #{@website_request.business_type}
  - **Design Preferences (freeform):** #{@website_request.design_preferences}
  - **Style Preferences (look & feel):** #{@website_request.style_preferences}
  - **Color Preferences:** #{@website_request.color_preferences}
  - **Inspiration Websites:** #{@website_request.inspiration_websites}
      - **Target Audience:** #{@website_request.target_audience}
    PROMPT

    # 3. Run the agent system
    # The AI will now follow its instructions, using the initial prompt as its guide,
    # and start calling the FileTool to write files to the specified directory.
    result = @runner.run(initial_prompt)

    if result.success?
      # The real result is the directory path, not the AI's final text output.
      @website_request.update(status: 'complete')
      directory_path.to_s # Return the path where files were generated
    else
      @website_request.update(status: 'failed')
       error_message = if result.error
                      result.error.message
       else
                      "An unknown error occurred. The AI response may have been malformed or incomplete."
       end

    Rails.logger.error "AI Website Generation Failed: #{error_message}"
    Rails.logger.error "Full AI result object: #{result.inspect}"
      nil
    end
  end
end