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

ActiveRecord::Schema.define(version: 2019_02_14_100819) do

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "male"
    t.string "company_name"
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
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["coach"], name: "index_admins_on_coach"
    t.index ["company"], name: "index_admins_on_company"
    t.index ["company_name"], name: "index_admins_on_company_name"
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["fname"], name: "index_admins_on_fname"
    t.index ["lname"], name: "index_admins_on_lname"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
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
    t.bigint "current_turn"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_games_on_active"
    t.index ["admin_id"], name: "index_games_on_admin_id"
    t.index ["current_turn"], name: "index_games_on_current_turn"
    t.index ["state"], name: "index_games_on_state"
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

  create_table "root_admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "root_id"
    t.bigint "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_root_admins_on_admin_id"
    t.index ["root_id"], name: "index_root_admins_on_root_id"
  end

  create_table "roots", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_roots_on_username"
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
    t.index ["place"], name: "index_turns_on_place"
    t.index ["play"], name: "index_turns_on_play"
    t.index ["played"], name: "index_turns_on_played"
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
    t.string "fname"
    t.string "lname"
    t.string "avatar"
    t.boolean "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["admin_id"], name: "index_users_on_admin_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "words", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "sound"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_words_on_name"
    t.index ["sound"], name: "index_words_on_sound"
  end

  add_foreign_key "game_ratings", "games"
  add_foreign_key "game_ratings", "teams"
  add_foreign_key "games", "admins"
  add_foreign_key "games", "teams"
  add_foreign_key "ratings", "admins"
  add_foreign_key "ratings", "turns"
  add_foreign_key "ratings", "users"
  add_foreign_key "root_admins", "admins"
  add_foreign_key "root_admins", "roots"
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
