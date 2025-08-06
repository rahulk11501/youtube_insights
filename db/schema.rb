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

ActiveRecord::Schema[8.0].define(version: 2025_08_06_142652) do
  create_table "channel_lookups", force: :cascade do |t|
    t.string "input"
    t.string "channel_id"
    t.string "title"
    t.text "description"
    t.string "thumbnail_url"
    t.integer "subscriber_count"
    t.integer "video_count"
    t.integer "view_count"
    t.datetime "last_fetched_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "video_lookups", force: :cascade do |t|
    t.string "video_id"
    t.string "title"
    t.text "description"
    t.string "thumbnail_url"
    t.datetime "published_at"
    t.string "channel_id"
    t.string "channel_title"
    t.integer "view_count"
    t.integer "like_count"
    t.integer "comment_count"
    t.datetime "last_fetched_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["video_id"], name: "index_video_lookups_on_video_id"
  end
end
