# frozen_string_literal: true

class AddIndexToUserRoles < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :admin
    add_index :users, :teacher
    add_index :users, :student
  end
end
