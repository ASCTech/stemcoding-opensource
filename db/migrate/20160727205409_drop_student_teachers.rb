# frozen_string_literal: true

class DropStudentTeachers < ActiveRecord::Migration[4.2]
  def change
    drop_table :student_teachers if table_exists?(:student_teachers)
  end
end
