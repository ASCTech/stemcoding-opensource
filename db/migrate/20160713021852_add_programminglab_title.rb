# frozen_string_literal: true

# This adds a title field for programming labs.
class AddProgramminglabTitle < ActiveRecord::Migration[4.2]
  def change
    add_column :programming_labs, :title, :string, null: false
  end
end
