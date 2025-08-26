class CreateGeneratedPages < ActiveRecord::Migration[8.0]
  def change
    create_table :generated_pages do |t|
      t.references :website_request, null: false, foreign_key: true
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
