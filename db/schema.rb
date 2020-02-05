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

ActiveRecord::Schema.define(version: 20171127020420) do

  create_table "camp_instructors", force: :cascade do |t|
    t.integer "camp_id"
    t.integer "instructor_id"
    t.index ["camp_id"], name: "index_camp_instructors_on_camp_id"
    t.index ["instructor_id"], name: "index_camp_instructors_on_instructor_id"
  end

  create_table "camps", force: :cascade do |t|
    t.integer "curriculum_id"
    t.integer "location_id"
    t.float "cost"
    t.date "start_date"
    t.date "end_date"
    t.string "time_slot"
    t.integer "max_students"
    t.boolean "active", default: true
    t.index ["curriculum_id"], name: "index_camps_on_curriculum_id"
    t.index ["location_id"], name: "index_camps_on_location_id"
  end

  create_table "curriculums", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "min_rating"
    t.integer "max_rating"
    t.boolean "active", default: true
  end

  create_table "families", force: :cascade do |t|
    t.string "family_name"
    t.string "parent_first_name"
    t.integer "user_id"
    t.boolean "active", default: true
    t.index ["user_id"], name: "index_families_on_user_id"
  end

  create_table "instructors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "bio"
    t.integer "user_id"
    t.boolean "active", default: true
    t.index ["user_id"], name: "index_instructors_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "street_1"
    t.string "street_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.integer "max_capacity"
    t.boolean "active", default: true
  end

  create_table "registrations", force: :cascade do |t|
    t.integer "camp_id"
    t.integer "student_id"
    t.string "payment"
    t.index ["camp_id"], name: "index_registrations_on_camp_id"
    t.index ["student_id"], name: "index_registrations_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "family_id"
    t.date "date_of_birth"
    t.integer "rating", default: 0
    t.boolean "active", default: true
    t.index ["family_id"], name: "index_students_on_family_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "role"
    t.string "email"
    t.string "phone"
    t.boolean "active", default: true
  end

end
