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

ActiveRecord::Schema[7.2].define(version: 2025_07_21_143240) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "code_project_files", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "code_project_id", null: false
    t.string "name", null: false
    t.text "content", null: false
    t.index ["code_project_id"], name: "index_code_project_files_on_code_project_id"
  end

  create_table "code_projects", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.text "description", default: "", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "course_programming_lab_id"
    t.index ["user_id"], name: "index_code_projects_on_user_id"
  end

  create_table "course_programming_labs", id: :serial, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "programming_lab_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "submittable", default: true, null: false
    t.integer "position", null: false
    t.index ["course_id", "position"], name: "index_course_programming_labs_on_course_id_and_position"
    t.index ["course_id", "programming_lab_id"], name: "index_course_programming_labs_on_course_lab_id", unique: true
  end

  create_table "course_teachers", id: :serial, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "teacher_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_id", "teacher_id"], name: "index_course_teachers_on_course_teacher_id", unique: true
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "title", null: false
    t.text "description", default: "", null: false
    t.integer "creator_id", null: false
    t.boolean "template", default: false, null: false
    t.string "join_key"
    t.integer "course_programming_labs_count", default: 0, null: false
    t.index ["creator_id"], name: "index_courses_on_creator_id"
    t.index ["join_key"], name: "index_courses_on_join_key", unique: true
    t.index ["template"], name: "index_courses_on_template"
    t.index ["title"], name: "index_courses_on_title"
  end

  create_table "enrollments", id: :serial, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "student_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_id", "student_id"], name: "index_enrollments_on_course_id_and_student_id", unique: true
  end

  create_table "lab_file_groups", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "downloadable", default: false, null: false
    t.string "key", null: false
    t.integer "programming_lab_id", null: false
    t.string "title", null: false
    t.index ["programming_lab_id", "key"], name: "index_lab_file_groups_on_programming_lab_id_and_key", unique: true
  end

  create_table "programming_lab_files", id: :serial, force: :cascade do |t|
    t.string "file", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "lab_file_group_id", null: false
    t.index ["lab_file_group_id"], name: "index_programming_lab_files_on_lab_file_group_id"
  end

  create_table "programming_labs", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "title", null: false
    t.text "content", null: false
    t.integer "creator_id", null: false
    t.boolean "template", default: false, null: false
    t.text "teacher_notes"
    t.boolean "use_norandom_p5", default: false, null: false
    t.index ["title"], name: "index_programming_labs_on_title", unique: true
  end

  create_table "render_files", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "expires", precision: nil, null: false
    t.text "content", null: false
    t.string "name", null: false
    t.integer "user_id", null: false
  end

  create_table "submission_files", id: :serial, force: :cascade do |t|
    t.integer "submission_id", null: false
    t.string "file", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "submissions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "student_comment", default: "", null: false
    t.text "instructor_comment", default: "", null: false
    t.float "grade"
    t.integer "course_programming_lab_id", null: false
    t.string "author_type", null: false
    t.integer "author_id", null: false
    t.index ["author_type", "author_id"], name: "index_submissions_on_author_type_and_author_id"
    t.index ["course_programming_lab_id"], name: "index_submissions_on_course_programming_lab_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "prefix"
    t.boolean "admin", default: false, null: false
    t.string "suffix"
    t.boolean "student", default: true, null: false
    t.boolean "teacher", default: false, null: false
    t.datetime "last_active_at", precision: nil
    t.boolean "super_teacher", default: false, null: false
    t.integer "course_teachers_count", default: 0, null: false
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["student"], name: "index_users_on_student"
    t.index ["teacher"], name: "index_users_on_teacher"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "code_project_files", "code_projects"
  add_foreign_key "code_projects", "users"
  add_foreign_key "course_programming_labs", "courses"
  add_foreign_key "course_programming_labs", "programming_labs"
  add_foreign_key "course_teachers", "courses"
  add_foreign_key "course_teachers", "users", column: "teacher_id"
  add_foreign_key "courses", "users", column: "creator_id"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "users", column: "student_id"
  add_foreign_key "lab_file_groups", "programming_labs", on_delete: :cascade
  add_foreign_key "programming_lab_files", "lab_file_groups"
  add_foreign_key "render_files", "users", on_delete: :nullify
  add_foreign_key "submission_files", "submissions", on_delete: :cascade
  add_foreign_key "submissions", "course_programming_labs"

  create_view "most_recent_submissions", sql_definition: <<-SQL
      WITH ranked_submissions AS (
           SELECT submissions.id,
              submissions.created_at,
              submissions.updated_at,
              submissions.student_comment,
              submissions.instructor_comment,
              submissions.grade,
              submissions.course_programming_lab_id,
              submissions.author_type,
              submissions.author_id,
              row_number() OVER (PARTITION BY submissions.course_programming_lab_id, submissions.author_type, submissions.author_id ORDER BY submissions.created_at DESC) AS rank
             FROM submissions
            ORDER BY submissions.course_programming_lab_id
          )
   SELECT id,
      id AS submission_id,
      created_at,
      updated_at,
      student_comment,
      instructor_comment,
      grade,
      course_programming_lab_id,
      author_type,
      author_id
     FROM ranked_submissions
    WHERE (rank = 1);
  SQL
end
