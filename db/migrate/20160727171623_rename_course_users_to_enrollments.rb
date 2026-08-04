# frozen_string_literal: true

# This renames the table from course_users to enrollments to better relfect
# the intention of this join table.
class RenameCourseUsersToEnrollments < ActiveRecord::Migration[4.2]
  def change
    rename_table :course_users, :enrollments
  end
end
