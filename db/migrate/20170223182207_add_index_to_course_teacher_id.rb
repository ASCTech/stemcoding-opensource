# frozen_string_literal: true

class AddIndexToCourseTeacherId < ActiveRecord::Migration[5.0]
  def change
    add_index :courses, :teacher_id
  end
end
