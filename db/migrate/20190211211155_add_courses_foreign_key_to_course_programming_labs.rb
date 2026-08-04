# frozen_string_literal: true

class AddCoursesForeignKeyToCourseProgrammingLabs < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :course_programming_labs, :courses
  end
end
