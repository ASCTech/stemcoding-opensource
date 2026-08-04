# frozen_string_literal: true

class AddUsersForeignKeyToCourseTeachers < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :course_teachers, :users, column: :teacher_id
  end
end
