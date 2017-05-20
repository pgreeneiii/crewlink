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

ActiveRecord::Schema.define(version: 20170520032737) do

  create_table "friends", force: :cascade do |t|
    t.integer  "username_id"
    t.integer  "friend_id"
    t.boolean  "favorite_status"
    t.boolean  "approval_status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "gamers", force: :cascade do |t|
    t.string   "email"
    t.string   "username"
    t.string   "password"
    t.string   "steam_username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "profile_img"
    t.integer  "last_played_game"
    t.boolean  "online_status"
    t.integer  "in_game_status"
    t.boolean  "looking_to_play_status"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "games", force: :cascade do |t|
    t.string   "title"
    t.string   "developer"
    t.boolean  "multiplayer_status"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "app_id"
  end

  create_table "libraries", force: :cascade do |t|
    t.integer  "owner_id"
    t.integer  "game_id"
    t.boolean  "default_looking_to_play_status"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "recipient_id"
    t.integer  "sender_id"
    t.text     "message"
    t.boolean  "read_status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
