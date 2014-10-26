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

ActiveRecord::Schema.define(version: 20141026005446) do

  create_table "entries", force: true do |t|
    t.string "url"
    t.string "title"
    t.string "summary"
    t.datetime "published"
    t.boolean "checked", default: false
    t.integer "feed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
  end

  add_index "entries", ["feed_id"], name: "index_entries_on_feed_id"

  create_table "feeds", force: true do |t|
    t.string "title"
    t.string "url"
    t.boolean "use"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_updated", default: '1970-01-01 00:00:00', null: false
  end

  create_table "notices", force: true do |t|
    t.string "title"
    t.string "summary"
    t.boolean "checked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published"
  end

  create_table "settings", force: true do |t|
    t.integer "frequency", default: 14400
    t.string "feedlist", default: "config/feeds.txt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "mode", default: false
    t.integer "style", default: 1
    t.integer "expiration", default: 86400
    t.boolean "autocleanup", default: true
  end

end
