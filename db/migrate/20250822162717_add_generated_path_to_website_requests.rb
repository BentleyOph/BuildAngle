class AddGeneratedPathToWebsiteRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :website_requests, :generated_path, :string
  end
end
