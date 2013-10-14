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

ActiveRecord::Schema.define(version: 20131014193237) do

  create_table "cards", force: true do |t|
    t.string   "state",      default: "new"
    t.text     "front"
    t.text     "back"
    t.text     "source"
    t.text     "source_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dictionaries", force: true do |t|
    t.string   "name",                      null: false
    t.string   "from_lang",                 null: false
    t.string   "to_lang",                   null: false
    t.string   "url_pattern",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "score",       default: 0.0, null: false
  end

end
