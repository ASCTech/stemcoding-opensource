# frozen_string_literal: true

# This creates the table CourseUsers, later to be refactored into enrollments.
class CreateCourseUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :course_users do |t|
      t.integer "course_id", null: false
      t.integer "user_id", null: false
      t.timestamps null: false
    end

    add_index :course_users,
              [:course_id, :user_id],
              unique: true
  end
end
