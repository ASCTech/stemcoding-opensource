# frozen_string_literal: true

class AddIndexToCourseTemplate < ActiveRecord::Migration[5.0]
  def change
    add_index :courses, :template
  end
end
