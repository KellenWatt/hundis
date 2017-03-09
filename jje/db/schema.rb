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

ActiveRecord::Schema.define(version: 20170309063910) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "problem_keywords", id: false, force: :cascade do |t|
    t.integer  "problem_id", null: false
    t.string   "keyword",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "problem_tags", id: false, force: :cascade do |t|
    t.integer  "problem_id", null: false
    t.string   "tag",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "problems", primary_key: "problem_id", force: :cascade do |t|
    t.string   "name"
    t.integer  "score"
    t.text     "problem_description"
    t.string   "path"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "tournament_languages", id: false, force: :cascade do |t|
    t.integer  "tournament_id", null: false
    t.string   "language",      null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "tournaments", id: false, force: :cascade do |t|
    t.integer  "tournament_id", null: false
    t.datetime "start"
    t.datetime "end"
    t.boolean  "checktime"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.string   "university"
    t.integer  "score"
    t.string   "company"
    t.string   "display_name"
    t.string   "email"
    t.string   "hash"
    t.string   "salt"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
