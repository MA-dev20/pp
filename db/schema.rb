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

ActiveRecord::Schema.define(version: 2018_12_31_152342) do

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "male"
    t.string "company_name"
    t.string "email"
    t.string "password_digest"
    t.string "fname"
    t.string "lname"
    t.string "street"
    t.string "city"
    t.string "avatar"
    t.string "logo"
    t.integer "employees"
    t.integer "zipcode"
    t.boolean "coach"
    t.boolean "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_ratings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "team_id"
    t.integer "ges"
    t.integer "body"
    t.integer "creative"
    t.integer "rhetoric"
    t.integer "spontan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_ratings_on_game_id"
    t.index ["team_id"], name: "index_game_ratings_on_team_id"
  end

  create_table "games", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "team_id"
    t.string "state"
    t.string "password"
    t.integer "current_turn"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_games_on_admin_id"
    t.index ["team_id"], name: "index_games_on_team_id"
  end

  create_table "ratings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "turn_id"
    t.bigint "user_id"
    t.bigint "admin_id"
    t.integer "ges"
    t.integer "body"
    t.integer "creative"
    t.integer "rhetoric"
    t.integer "spontan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_ratings_on_admin_id"
    t.index ["turn_id"], name: "index_ratings_on_turn_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "roots", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_ratings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "team_id"
    t.integer "ges"
    t.integer "body"
    t.integer "creative"
    t.integer "rhetoric"
    t.integer "spontan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_ratings_on_team_id"
  end

  create_table "team_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_users_on_team_id"
    t.index ["user_id"], name: "index_team_users_on_user_id"
  end

  create_table "teams", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "admin_id"
    t.string "name"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_teams_on_admin_id"
  end

  create_table "turn_ratings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "turn_id"
    t.bigint "game_id"
    t.bigint "user_id"
    t.bigint "admin_id"
    t.integer "ges"
    t.integer "body"
    t.integer "creative"
    t.integer "rhetoric"
    t.integer "spontan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_turn_ratings_on_admin_id"
    t.index ["game_id"], name: "index_turn_ratings_on_game_id"
    t.index ["turn_id"], name: "index_turn_ratings_on_turn_id"
    t.index ["user_id"], name: "index_turn_ratings_on_user_id"
  end

  create_table "turns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "word_id"
    t.bigint "user_id"
    t.bigint "admin_id"
    t.integer "place"
    t.boolean "play"
    t.boolean "played"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_turns_on_admin_id"
    t.index ["game_id"], name: "index_turns_on_game_id"
    t.index ["user_id"], name: "index_turns_on_user_id"
    t.index ["word_id"], name: "index_turns_on_word_id"
  end

  create_table "user_ratings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "ges"
    t.integer "body"
    t.integer "creative"
    t.integer "rhetoric"
    t.integer "spontan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_ratings_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "admin_id"
    t.string "company_name"
    t.string "email"
    t.string "password_digest"
    t.string "fname"
    t.string "lname"
    t.string "avatar"
    t.boolean "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_users_on_admin_id"
  end

  create_table "words", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "sound"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "game_ratings", "games"
  add_foreign_key "game_ratings", "teams"
  add_foreign_key "games", "admins"
  add_foreign_key "games", "teams"
  add_foreign_key "ratings", "admins"
  add_foreign_key "ratings", "turns"
  add_foreign_key "ratings", "users"
  add_foreign_key "team_ratings", "teams"
  add_foreign_key "team_users", "teams"
  add_foreign_key "team_users", "users"
  add_foreign_key "teams", "admins"
  add_foreign_key "turn_ratings", "admins"
  add_foreign_key "turn_ratings", "games"
  add_foreign_key "turn_ratings", "turns"
  add_foreign_key "turn_ratings", "users"
  add_foreign_key "turns", "admins"
  add_foreign_key "turns", "games"
  add_foreign_key "turns", "users"
  add_foreign_key "turns", "words"
  add_foreign_key "user_ratings", "users"
  add_foreign_key "users", "admins"
end
