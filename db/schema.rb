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

ActiveRecord::Schema.define(version: 20140715113935) do

  create_table "episodes", force: true do |t|
    t.string   "title"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default"
    t.text     "chatroom"
  end

  create_table "images", force: true do |t|
    t.string   "name"
    t.string   "msg"
    t.string   "author"
    t.binary   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type"
    t.integer  "episode_id"
    t.string   "user"
    t.string   "avatar"
  end

end