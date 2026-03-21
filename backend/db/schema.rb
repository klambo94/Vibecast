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

ActiveRecord::Schema[8.1].define(version: 2026_03_21_003920) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "recommendations", force: :cascade do |t|
    t.string "artist"
    t.datetime "created_at", null: false
    t.boolean "favorite"
    t.string "genre"
    t.text "reason"
    t.string "track"
    t.datetime "updated_at", null: false
    t.bigint "vibe_session_id", null: false
    t.index ["vibe_session_id"], name: "index_recommendations_on_vibe_session_id"
  end

  create_table "vibe_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "mood_input"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "recommendations", "vibe_sessions"
end
