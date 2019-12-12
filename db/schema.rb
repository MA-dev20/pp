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

ActiveRecord::Schema.define(version: 2019_12_12_140054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "company_name"
    t.string "fname"
    t.string "lname"
    t.string "street"
    t.string "city"
    t.string "avatar"
    t.string "logo"
    t.integer "employees"
    t.integer "zipcode"
    t.boolean "male"
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
    t.integer "token"
    t.string "vid_token"
    t.integer "members"
    t.string "stripe_id"
    t.date "expiration"
    t.boolean "annually"
    t.boolean "monthy"
    t.string "password_confirm"
    t.string "plan_id"
    t.integer "plan_type"
    t.integer "plan_users"
    t.string "admin_subscription_id"
    t.boolean "verification_code_confirm", default: false
    t.string "reset_pw_token"
    t.string "telephone"
    t.string "company_position"
    t.boolean "activated"
    t.string "message"
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "set_default_card"
    t.string "stripe_card_id"
    t.integer "last_4_cards_digit"
    t.integer "expiry_month"
    t.integer "expiry_year"
    t.string "card_brand"
    t.string "stripe_custommer_id"
    t.index ["admin_id"], name: "index_cards_on_admin_id"
  end

  create_table "catchwords_basket_words", force: :cascade do |t|
    t.bigint "word_id"
    t.bigint "catchwords_basket_id"
    t.index ["catchwords_basket_id"], name: "index_catchwords_basket_words_on_catchwords_basket_id"
    t.index ["word_id"], name: "index_catchwords_basket_words_on_word_id"
  end

  create_table "catchwords_baskets", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "type"
    t.boolean "objection", default: false
    t.integer "image"
    t.index ["admin_id"], name: "index_catchwords_baskets_on_admin_id"
    t.index ["game_id"], name: "index_catchwords_baskets_on_game_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "type_of_comment"
    t.integer "time_of_video"
    t.string "title"
    t.bigint "turn_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "release_it", default: false
    t.index ["turn_id"], name: "index_comments_on_turn_id"
  end

  create_table "game_ratings", force: :cascade do |t|
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

  create_table "games", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "team_id"
    t.string "state"
    t.string "password"
    t.integer "current_turn"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "wait_seconds", default: 80
    t.boolean "own_words", default: false
    t.boolean "uses_peterwords", default: false
    t.boolean "video_uploading", default: false
    t.integer "turn1"
    t.integer "turn2"
    t.boolean "use_peterobjections", default: false
    t.string "youtube_url"
    t.boolean "video_toggle", default: false
    t.bigint "video_id"
    t.boolean "peter_sound", default: true
    t.boolean "game_sound", default: true
    t.integer "video"
    t.boolean "video_is_pitch"
    t.boolean "replay", default: false
    t.index ["admin_id"], name: "index_games_on_admin_id"
    t.index ["team_id"], name: "index_games_on_team_id"
    t.index ["video_id"], name: "index_games_on_video_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "amount_paid"
    t.string "plan_id"
    t.string "card_number"
    t.string "invoice_interval"
    t.boolean "invoice_paid"
    t.string "invoice_currency"
    t.string "stripe_invoice_id"
    t.bigint "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_invoices_on_admin_id"
  end

  create_table "objection_basket_objections", force: :cascade do |t|
    t.integer "objection_id"
    t.integer "objections_basket_id"
  end

  create_table "plans", force: :cascade do |t|
    t.integer "amount"
    t.string "product_name"
    t.string "interval"
    t.string "currency"
    t.string "stripe_plan_id"
    t.bigint "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["admin_id"], name: "index_plans_on_admin_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "turn_id"
    t.integer "user_id"
    t.integer "admin_id"
    t.integer "ges"
    t.integer "body"
    t.integer "creative"
    t.integer "rhetoric"
    t.integer "spontan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "disabled", default: false
    t.index ["turn_id"], name: "index_ratings_on_turn_id"
  end

  create_table "root_admins", force: :cascade do |t|
    t.bigint "root_id"
    t.bigint "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_root_admins_on_admin_id"
    t.index ["root_id"], name: "index_root_admins_on_root_id"
  end

  create_table "roots", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.boolean "edit_words"
    t.boolean "edit_admins"
    t.boolean "edit_root"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "plan_id"
    t.string "subscription_id"
    t.integer "user_id"
    t.bigint "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_subscriptions_on_admin_id"
  end

  create_table "team_ratings", force: :cascade do |t|
    t.bigint "team_id"
    t.integer "ges"
    t.integer "body"
    t.integer "creative"
    t.integer "rhetoric"
    t.integer "spontan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "change_ges"
    t.integer "change_body"
    t.integer "change_creative"
    t.integer "change_rhetoric"
    t.integer "change_spontan"
    t.index ["team_id"], name: "index_team_ratings_on_team_id"
  end

  create_table "team_users", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_users_on_team_id"
    t.index ["user_id"], name: "index_team_users_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "admin_id"
    t.string "name"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_teams_on_admin_id"
  end

  create_table "turn_ratings", force: :cascade do |t|
    t.bigint "turn_id"
    t.bigint "game_id"
    t.integer "user_id"
    t.integer "admin_id"
    t.integer "ges"
    t.integer "body"
    t.integer "creative"
    t.integer "rhetoric"
    t.integer "spontan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ended", default: false
    t.index ["game_id"], name: "index_turn_ratings_on_game_id"
    t.index ["turn_id"], name: "index_turn_ratings_on_turn_id"
  end

  create_table "turns", force: :cascade do |t|
    t.bigint "game_id"
    t.integer "user_id"
    t.integer "admin_id"
    t.integer "place"
    t.boolean "play"
    t.boolean "played"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "word_id"
    t.string "status", default: "pending"
    t.boolean "admin_turn", default: false
    t.string "recorded_pitch"
    t.integer "recorded_pitch_duration"
    t.datetime "click_time"
    t.integer "counter"
    t.boolean "favorite", default: false
    t.index ["game_id"], name: "index_turns_on_game_id"
  end

  create_table "user_ratings", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "ges"
    t.integer "body"
    t.integer "creative"
    t.integer "rhetoric"
    t.integer "spontan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "change_ges"
    t.integer "change_body"
    t.integer "change_creative"
    t.integer "change_rhetoric"
    t.integer "change_spontan"
    t.index ["user_id"], name: "index_user_ratings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.integer "status", default: 2
    t.string "encrypted_pw"
    t.string "street"
    t.string "zipcode"
    t.string "city"
    t.string "logo"
    t.index ["admin_id"], name: "index_users_on_admin_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.bigint "admin_id"
    t.string "name"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_videos_on_admin_id"
  end

  create_table "words", force: :cascade do |t|
    t.string "name"
    t.string "sound"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "free"
    t.string "type"
  end

  add_foreign_key "catchwords_basket_words", "catchwords_baskets"
  add_foreign_key "catchwords_basket_words", "words"
  add_foreign_key "catchwords_baskets", "admins"
  add_foreign_key "catchwords_baskets", "games"
  add_foreign_key "comments", "turns"
  add_foreign_key "game_ratings", "games"
  add_foreign_key "game_ratings", "teams"
  add_foreign_key "games", "admins"
  add_foreign_key "games", "teams"
  add_foreign_key "games", "videos"
  add_foreign_key "ratings", "turns"
  add_foreign_key "root_admins", "admins"
  add_foreign_key "root_admins", "roots"
  add_foreign_key "team_ratings", "teams"
  add_foreign_key "team_users", "teams"
  add_foreign_key "team_users", "users"
  add_foreign_key "teams", "admins"
  add_foreign_key "turn_ratings", "games"
  add_foreign_key "turn_ratings", "turns"
  add_foreign_key "turns", "games"
  add_foreign_key "user_ratings", "users"
  add_foreign_key "users", "admins"
  add_foreign_key "videos", "admins"
end
