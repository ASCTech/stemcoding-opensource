# frozen_string_literal: true

class AddIndexToStudentTeachers < ActiveRecord::Migration[4.2]
  def change
    add_index :student_teachers, %i[student_id teacher_id], unique: true if table_exists?(:student_teachers)
  end
end
