# frozen_string_literal: true

class AddCoursesForeignKeyToEnrollments < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :enrollments, :courses
  end
end
