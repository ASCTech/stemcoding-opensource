# frozen_string_literal: true

class AddCoursesForeignKeyToCourseTeachers < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :course_teachers, :courses
  end
end
