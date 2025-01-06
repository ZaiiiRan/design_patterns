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

ActiveRecord::Schema[8.0].define(version: 2024_12_18_132626) do
  create_table "labs", force: :cascade do |t|
    t.string "name", null: false
    t.string "topics"
    t.string "tasks"
    t.date "date_of_issue", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "marks", force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "lab_id", null: false
    t.string "grade", null: false
    t.date "due_date", null: false
    t.string "comment", limit: 100
    t.text "justification", limit: 1000
    t.boolean "final", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lab_id"], name: "index_marks_on_lab_id"
    t.index ["student_id"], name: "index_marks_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "name", null: false
    t.string "patronymic", null: false
    t.string "telegram"
    t.string "email"
    t.string "phone_number"
    t.string "git"
    t.date "birthdate", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "marks", "labs"
  add_foreign_key "marks", "students"
end
