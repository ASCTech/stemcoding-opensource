# frozen_string_literal: true

class AddIndexToCourseTitle < ActiveRecord::Migration[5.0]
  def change
    add_index :courses, :title
  end
end
