# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_15_175900) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "alive", default: true, null: false
    t.string "name"
    t.string "gender_identity"
    t.datetime "date_of_birth"
    t.datetime "deceased_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "profession_id"
    t.index ["profession_id"], name: "index_characters_on_profession_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "professions", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "email"
    t.string "uid"
    t.string "name"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "characters", "professions"
  add_foreign_key "characters", "users"
end
