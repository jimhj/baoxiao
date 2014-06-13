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

ActiveRecord::Schema.define(version: 20140613064909) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jokes", force: true do |t|
    t.integer  "user_id"
    t.boolean  "anonymous"
    t.string   "title"
    t.text     "content",                        null: false
    t.string   "picture"
    t.integer  "status",           default: 0
    t.integer  "up_votes_count",   default: 0
    t.integer  "down_votes_count", default: 0
    t.integer  "comments_count"
    t.string   "from"
    t.float    "hot",              default: 0.0
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jokes", ["from"], name: "index_jokes_on_from", using: :btree
  add_index "jokes", ["hot"], name: "index_jokes_on_hot", using: :btree
  add_index "jokes", ["user_id"], name: "index_jokes_on_user_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "name"
    t.string   "password_digest"
    t.string   "avatar"
    t.datetime "locked_at"
    t.boolean  "confirmed",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "voted_joke_ids",  default: [],    array: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

end
