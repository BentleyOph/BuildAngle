class AddStyleColorInspirationToWebsiteRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :website_requests, :style_preferences, :text
    add_column :website_requests, :color_preferences, :string
    add_column :website_requests, :inspiration_websites, :text
  end
end
