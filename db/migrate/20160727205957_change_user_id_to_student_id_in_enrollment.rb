# frozen_string_literal: true

# This class changes the user id to be student id in the enrollment join table
# to help increase readability and clarity.
class ChangeUserIdToStudentIdInEnrollment < ActiveRecord::Migration[4.2]
  def change
    rename_column :enrollments, :user_id, :student_id
  end
end
