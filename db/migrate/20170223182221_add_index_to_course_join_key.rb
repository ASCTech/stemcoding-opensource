# frozen_string_literal: true

class AddIndexToCourseJoinKey < ActiveRecord::Migration[5.0]
  def change
    add_index :courses, :join_key, unique: true
  end
end
