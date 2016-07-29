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

ActiveRecord::Schema.define(version: 20160728204317) do

  create_table "fixtures", force: :cascade do |t|
    t.integer  "home_team_id"
    t.integer  "home_team_score"
    t.integer  "away_team_id"
    t.integer  "away_team_score"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "matchweek_id"
    t.integer  "winner_id"
  end

  create_table "matchweeks", force: :cascade do |t|
    t.integer  "week"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "picks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "result_points"
    t.integer  "result_gd"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "fixture_id"
    t.integer  "matchweek_id"
    t.index ["fixture_id"], name: "index_picks_on_fixture_id"
    t.index ["matchweek_id"], name: "index_picks_on_matchweek_id"
    t.index ["team_id"], name: "index_picks_on_team_id"
    t.index ["user_id"], name: "index_picks_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.string   "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
