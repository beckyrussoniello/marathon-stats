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

ActiveRecord::Schema.define(version: 20150131064828) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "divisions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "performances", force: :cascade do |t|
    t.integer  "runner_id"
    t.string   "bib_number"
    t.integer  "age"
    t.string   "location"
    t.time     "net_time"
    t.time     "gun_time"
    t.time     "average_pace"
    t.integer  "division_id"
    t.integer  "sex_id"
    t.integer  "division_place"
    t.integer  "sex_place"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "performances", ["division_id"], name: "index_performances_on_division_id", using: :btree
  add_index "performances", ["runner_id"], name: "index_performances_on_runner_id", using: :btree
  add_index "performances", ["sex_id"], name: "index_performances_on_sex_id", using: :btree

  create_table "races", force: :cascade do |t|
    t.string   "name"
    t.date     "date"
    t.string   "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "runners", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sexes", force: :cascade do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_foreign_key "performances", "divisions"
  add_foreign_key "performances", "runners"
  add_foreign_key "performances", "sexes"
end