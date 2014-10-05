# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141005153216) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "entries", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "text"
    t.datetime "time"
    t.integer  "FeedSource_id"
    t.boolean  "checked"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "entries", ["FeedSource_id"], name: "index_entries_on_FeedSource_id"
  add_index "entries", ["title"], name: "index_entries_on_title"

  create_table "feed_sources", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.boolean  "checked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "feed_sources", ["title"], name: "index_feed_sources_on_title"

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true

end
