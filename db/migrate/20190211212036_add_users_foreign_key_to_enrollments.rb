# frozen_string_literal: true

class AddUsersForeignKeyToEnrollments < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :enrollments, :users, column: :student_id
  end
end
