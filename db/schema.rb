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

ActiveRecord::Schema.define(version: 20131123210442) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "card_model_fields", force: true do |t|
    t.integer  "card_model_id", null: false
    t.integer  "order",         null: false
    t.string   "name",          null: false
    t.string   "card_attr",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "card_model_fields", ["card_model_id"], name: "index_card_model_fields_on_card_model_id"

  create_table "card_model_templates", force: true do |t|
    t.integer  "card_model_id",       null: false
    t.integer  "order",               null: false
    t.string   "name",                null: false
    t.text     "anki_front_template", null: false
    t.text     "anki_back_template",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "card_model_templates", ["card_model_id"], name: "index_card_model_templates_on_card_model_id"

  create_table "card_models", force: true do |t|
    t.string   "short_name",                 null: false
    t.string   "name",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "anki_css"
    t.boolean  "cloze",      default: false
  end

  create_table "cards", force: true do |t|
    t.string   "state",         default: "new"
    t.text     "front"
    t.text     "back"
    t.text     "source"
    t.text     "source_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "card_model_id"
  end

  add_index "cards", ["card_model_id"], name: "index_cards_on_card_model_id"
  add_index "cards", ["user_id", "state", "created_at", "id"], name: "index_cards_on_user_id_and_state_and_created_at_and_id"

  create_table "dictionaries", force: true do |t|
    t.string   "name",                      null: false
    t.string   "from_lang",                 null: false
    t.string   "to_lang",                   null: false
    t.string   "url_pattern",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "score",       default: 0.0, null: false
  end

  create_table "media_files", force: true do |t|
    t.integer  "card_id",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "url"
    t.string   "file_fingerprint"
  end

  add_index "media_files", ["card_id"], name: "index_media_files_on_card_id"

  create_table "users", force: true do |t|
    t.string   "email",                                  null: false
    t.string   "password_digest",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_key"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "admin",                  default: false
    t.boolean  "supporter",              default: false
    t.integer  "characters_translated",  default: 0
  end

  add_index "users", ["api_key"], name: "index_users_on_api_key", unique: true
  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true

end
