# frozen_string_literal: true

# This adds a joinkey column to a course.
class AddJoinKeyToCourse < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :join_key, :string, null: true
  end
end
