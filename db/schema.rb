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

ActiveRecord::Schema.define(version: 20141115130403) do

  create_table "admins", force: true do |t|
    t.string   "email",              default: ""
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",                        null: false
  end

  add_index "admins", ["username"], name: "index_admins_on_username", unique: true

  create_table "entries", force: true do |t|
    t.string   "url"
    t.string   "title"
    t.string   "summary"
    t.datetime "published"
    t.boolean  "checked",            default: false
    t.integer  "feed_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "entries", ["feed_id"], name: "index_entries_on_feed_id"

  create_table "feeds", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.boolean  "use"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.datetime "last_fetched", default: '1970-01-01 00:00:00'
  end

  create_table "notices", force: true do |t|
    t.string   "title"
    t.string   "summary"
    t.boolean  "checked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published"
  end

  create_table "settings", force: true do |t|
    t.integer  "frequency",               default: 14400
    t.string   "feedlist",                default: "config/feeds.txt"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.boolean  "mode",                    default: false
    t.integer  "style",                   default: 1
    t.integer  "expiration",              default: 86400
    t.boolean  "autocleanup",             default: true
    t.string   "noticelist",              default: "config/notices.md"
    t.float    "display_frequency",       default: 0.5
    t.string   "background_file_name"
    t.string   "background_content_type"
    t.integer  "background_file_size"
    t.datetime "background_updated_at"
  end

end
