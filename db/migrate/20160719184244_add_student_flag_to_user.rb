# frozen_string_literal: true

# This adds a boolean flag to user to indicate if they are a student. By default
# all users are students.
class AddStudentFlagToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :student, :boolean, null: false, default: true
  end
end
