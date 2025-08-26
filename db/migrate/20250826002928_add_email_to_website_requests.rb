class AddEmailToWebsiteRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :website_requests, :email, :string
  end
end
