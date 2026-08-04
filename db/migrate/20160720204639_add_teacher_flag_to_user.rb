# frozen_string_literal: true

# This adds the boolean flag to a user to indicate if they are  a teacher.
class AddTeacherFlagToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :teacher, :boolean, null: false, default: false
  end
end
