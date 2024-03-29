# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_10_131310) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "content", null: false
    t.integer "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read_flg", default: false, null: false
    t.index ["student_id", "created_at"], name: "index_contacts_on_student_id_and_created_at"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_students", id: false, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "student_id", null: false
    t.index ["student_id"], name: "index_groups_students_on_student_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "from_id"
    t.integer "to_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_id", "to_id"], name: "index_messages_on_from_id_and_to_id"
    t.index ["to_id", "from_id"], name: "index_messages_on_to_id_and_from_id"
  end

  create_table "news", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.integer "status", default: 0, null: false
    t.integer "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "upfile"
    t.index ["teacher_id", "created_at"], name: "index_news_on_teacher_id_and_created_at"
  end

  create_table "news_replies", id: :serial, force: :cascade do |t|
    t.string "content", limit: 500, null: false
    t.boolean "is_read", default: false, null: false
    t.bigint "sender_type", null: false
    t.integer "student_id", null: false
    t.integer "teacher_id", null: false
    t.integer "news_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["news_id"], name: "index_news_replies_on_news_id"
    t.index ["student_id"], name: "index_news_replies_on_student_id"
    t.index ["teacher_id"], name: "index_news_replies_on_teacher_id"
  end

  create_table "news_students", id: false, force: :cascade do |t|
    t.integer "news_id", null: false
    t.integer "student_id", null: false
    t.index ["student_id"], name: "index_news_students_on_student_id"
  end

  create_table "replies", id: :serial, force: :cascade do |t|
    t.text "content", null: false
    t.string "replyable_type"
    t.integer "replyable_id"
    t.string "writeable_type"
    t.integer "writeable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read_flg", default: false, null: false
    t.index ["replyable_type", "replyable_id"], name: "index_replies_on_replyable_type_and_replyable_id"
    t.index ["writeable_type", "writeable_id"], name: "index_replies_on_writeable_type_and_writeable_id"
  end

  create_table "reports", id: :serial, force: :cascade do |t|
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.string "subject"
    t.text "content"
    t.text "homework"
    t.text "comment"
    t.integer "status", default: 0, null: false
    t.boolean "read_flg", default: false, null: false
    t.text "memo"
    t.integer "student_id"
    t.integer "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id", "created_at"], name: "index_reports_on_student_id_and_created_at"
    t.index ["teacher_id", "created_at"], name: "index_reports_on_teacher_id_and_created_at"
  end

  create_table "students", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.string "grade"
    t.string "lesson_day"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "login_id"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "image"
    t.index ["grade"], name: "index_students_on_grade"
    t.index ["login_id"], name: "index_students_on_login_id", unique: true
  end

  create_table "teachers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "status", default: 0
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "image"
    t.index ["email"], name: "index_teachers_on_email", unique: true
  end

  add_foreign_key "contacts", "students"
  add_foreign_key "news", "teachers"
  add_foreign_key "news_replies", "news"
  add_foreign_key "news_replies", "students"
  add_foreign_key "news_replies", "teachers"
  add_foreign_key "reports", "students"
  add_foreign_key "reports", "teachers"
end
