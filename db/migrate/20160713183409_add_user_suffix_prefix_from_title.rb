# frozen_string_literal: true

# Adds suffix to a user, and renames the title to prefix.
class AddUserSuffixPrefixFromTitle < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :suffix, :string, null: true
    rename_column :users, :title, :prefix
  end
end
