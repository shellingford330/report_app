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

ActiveRecord::Schema.define(version: 20191026035821) do

  create_table "contacts", force: :cascade do |t|
    t.string   "title"
    t.text     "content",                    null: false
    t.integer  "student_id"
    t.integer  "teacher_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "read_flg",   default: false, null: false
    t.index ["student_id", "created_at"], name: "index_contacts_on_student_id_and_created_at"
    t.index ["teacher_id", "created_at"], name: "index_contacts_on_teacher_id_and_created_at"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_students", id: false, force: :cascade do |t|
    t.integer "group_id",   null: false
    t.integer "student_id", null: false
    t.index ["student_id"], name: "index_groups_students_on_student_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_id", "to_id"], name: "index_messages_on_from_id_and_to_id"
    t.index ["to_id", "from_id"], name: "index_messages_on_to_id_and_from_id"
  end

  create_table "news", force: :cascade do |t|
    t.string   "title",                  null: false
    t.text     "content",                null: false
    t.integer  "status",     default: 0, null: false
    t.integer  "teacher_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["teacher_id", "created_at"], name: "index_news_on_teacher_id_and_created_at"
  end

  create_table "news_students", id: false, force: :cascade do |t|
    t.integer "news_id",    null: false
    t.integer "student_id", null: false
    t.index ["student_id"], name: "index_news_students_on_student_id"
  end

  create_table "replies", force: :cascade do |t|
    t.text     "content",                        null: false
    t.string   "replyable_type"
    t.integer  "replyable_id"
    t.string   "writeable_type"
    t.integer  "writeable_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "read_flg",       default: false, null: false
    t.index ["replyable_type", "replyable_id"], name: "index_replies_on_replyable_type_and_replyable_id"
    t.index ["writeable_type", "writeable_id"], name: "index_replies_on_writeable_type_and_writeable_id"
  end

  create_table "reports", force: :cascade do |t|
    t.date     "start_date",                 null: false
    t.date     "end_date",                   null: false
    t.string   "subject"
    t.text     "content"
    t.text     "homework"
    t.text     "comment"
    t.integer  "status",     default: 0,     null: false
    t.boolean  "read_flg",   default: false, null: false
    t.text     "memo"
    t.integer  "student_id"
    t.integer  "teacher_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["student_id", "created_at"], name: "index_reports_on_student_id_and_created_at"
    t.index ["teacher_id", "created_at"], name: "index_reports_on_teacher_id_and_created_at"
  end

  create_table "students", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "remember_digest"
    t.string   "grade"
    t.string   "lesson_day"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "login_id"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["grade"], name: "index_students_on_grade"
    t.index ["login_id"], name: "index_students_on_login_id", unique: true
  end

  create_table "teachers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "status",            default: 0
    t.string   "password_digest"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_teachers_on_email", unique: true
  end

end
