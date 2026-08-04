# frozen_string_literal: true

# This adds the first and last name of a user to the users table.
class AddUserFirstAndLastName < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string, null: false
    add_column :users, :title, :string, null: false
  end
end
