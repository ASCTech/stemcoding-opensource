# frozen_string_literal: true

class CreateCourseTeachers < ActiveRecord::Migration[5.0]
  def change
    create_table :course_teachers do |t|
      t.integer "course_id", null: false
      t.integer "teacher_id", null: false
      t.timestamps
    end

    add_index :course_teachers,
              [:course_id, :teacher_id],
              unique: true,
              name: "index_course_teachers_on_course_teacher_id"
  end
end
