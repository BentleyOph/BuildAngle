class AddDeploymentFieldsToWebsiteRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :website_requests, :deployed_at, :datetime
    add_column :website_requests, :repo_url, :string
  end
end
