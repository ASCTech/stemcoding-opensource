# frozen_string_literal: true

# This adds a column of type integer to link a course to a teacher.
class AddTeacherForeignKeyToCourses < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :teacher_id, :integer, null: true
  end
end
