class CreateWebsiteRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :website_requests do |t|
      t.string :business_name
      t.string :business_type
      t.text :design_preferences
      t.text :target_audience
      t.string :status

      t.timestamps
    end
  end
end
