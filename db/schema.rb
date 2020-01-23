# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_23_063946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: :cascade do |t|
    t.string "entry_id"
    t.text "data"
    t.datetime "created_on_contentful_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_on_contentful_at"], name: "index_entries_on_created_on_contentful_at"
    t.index ["entry_id"], name: "index_entries_on_entry_id", unique: true
  end

  create_table "sync_logs", force: :cascade do |t|
    t.integer "status"
    t.string "delta_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "time_out_at"
  end

end
