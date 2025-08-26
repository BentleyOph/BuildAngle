# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_26_002936) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "generated_pages", force: :cascade do |t|
    t.bigint "website_request_id", null: false
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["website_request_id"], name: "index_generated_pages_on_website_request_id"
  end

  create_table "website_requests", force: :cascade do |t|
    t.string "business_name"
    t.string "business_type"
    t.text "design_preferences"
    t.text "target_audience"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "generated_path"
    t.text "style_preferences"
    t.string "color_preferences"
    t.text "inspiration_websites"
    t.string "email"
    t.datetime "deployed_at"
    t.string "repo_url"
  end

  add_foreign_key "generated_pages", "website_requests"
end
