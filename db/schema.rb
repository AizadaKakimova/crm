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

ActiveRecord::Schema.define(version: 20200130155138) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.integer "enrollment_id"
    t.datetime "day"
  end

  create_table "branches", force: :cascade do |t|
    t.bigint "city_id"
    t.string "name"
    t.string "phone"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_branches_on_city_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.boolean "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "costs", force: :cascade do |t|
    t.string "cost_name"
    t.integer "user_id"
    t.boolean "fix", default: false
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.string "file_name"
    t.integer "price", default: 0
    t.string "slug"
    t.boolean "visible", default: true
    t.integer "city_id", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "shown"
    t.text "description"
    t.string "image_link"
    t.string "level"
    t.string "duration"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.string "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "comment"
    t.integer "expected_value"
    t.integer "attend_days", default: 0
    t.date "last_day"
    t.float "coins", default: 10.0
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "groups", force: :cascade do |t|
    t.string "title"
    t.integer "course_id"
    t.integer "instructor_id"
    t.datetime "start"
    t.datetime "end"
    t.string "slug"
    t.integer "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "branch_id"
    t.string "time"
    t.string "day"
    t.string "hw"
  end

  create_table "items", force: :cascade do |t|
    t.string "picture"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status", default: true
    t.integer "request_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "sum"
    t.string "comment"
    t.integer "enrollment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "receiver_id"
    t.integer "course_id"
    t.integer "branch_id"
    t.integer "city_id"
  end

  create_table "program_tables", force: :cascade do |t|
    t.integer "course_id"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programs", force: :cascade do |t|
    t.integer "course_id"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number"
  end

  create_table "requests", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.string "time"
    t.integer "course_id"
    t.text "message"
    t.string "info"
    t.string "status", default: "Новая"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "branch_id"
    t.integer "city_id"
  end

  create_table "salaries", force: :cascade do |t|
    t.integer "user_id"
    t.integer "monthly", default: 0
    t.integer "hourly", default: 0
    t.string "role", default: "user"
    t.boolean "full_time", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "super_users", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teaching_hours", force: :cascade do |t|
    t.integer "instructor_id"
    t.integer "group_id"
    t.float "hours", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "individual", default: false
  end

  create_table "teaching_hours_individs", force: :cascade do |t|
    t.integer "instructor_id"
    t.float "hours", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "todos", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.datetime "deadline"
    t.string "status"
    t.integer "todo_maker"
    t.integer "todo_sender"
    t.index ["user_id"], name: "index_todos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.string "name"
    t.string "school"
    t.datetime "birthdate"
    t.string "phone"
    t.integer "branch_id"
    t.integer "city_id"
    t.string "image_link"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  create_table "users_branches", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "branch_id"
    t.index ["branch_id"], name: "index_users_branches_on_branch_id"
    t.index ["user_id"], name: "index_users_branches_on_user_id"
  end

  add_foreign_key "todos", "users"
  add_foreign_key "users_branches", "branches"
  add_foreign_key "users_branches", "users"
end
