# frozen_string_literal: true

# This adds the content field of type text to a programming lab.
class AddProgrammingLabContent < ActiveRecord::Migration[4.2]
  def change
    add_column :programming_labs, :content, :text, null: false
  end
end
