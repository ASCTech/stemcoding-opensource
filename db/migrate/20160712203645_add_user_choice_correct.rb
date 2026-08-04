# frozen_string_literal: true

# This adds the correct flag to a choice.
class AddUserChoiceCorrect < ActiveRecord::Migration[4.2]
  def change
    add_column :choices, :correct, :boolean, null: false, default: false if table_exists?(:choices)
  end
end
