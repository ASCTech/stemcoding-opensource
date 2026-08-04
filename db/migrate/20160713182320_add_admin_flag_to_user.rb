# frozen_string_literal: true

# Adds an admin flag to user.
class AddAdminFlagToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
  end
end
