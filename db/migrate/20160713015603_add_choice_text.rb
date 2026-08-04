# frozen_string_literal: true

# This adds the text to accompany a choice.
class AddChoiceText < ActiveRecord::Migration[4.2]
  def change
    add_column :choices, :text, :string, null: false if table_exists?(:choices)
  end
end
