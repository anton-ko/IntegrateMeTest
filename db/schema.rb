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

ActiveRecord::Schema.define(version: 20180321235207) do

  create_table "accounts", force: :cascade do |t|
    t.string "mailchimp_key"
  end

  create_table "competitions", force: :cascade do |t|
    t.string   "name"
    t.boolean  "requires_entry_name", default: true
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "account_id"
    t.string   "mailing_list_id"
  end

  add_index "competitions", ["account_id"], name: "index_competitions_on_account_id"

  create_table "entries", force: :cascade do |t|
    t.integer  "competition_id"
    t.text     "name"
    t.text     "email"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "entries", ["competition_id", "email"], name: "index_entries_on_competition_id_and_email", unique: true

end
