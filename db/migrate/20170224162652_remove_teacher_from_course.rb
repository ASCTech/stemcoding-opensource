# frozen_string_literal: true

class RemoveTeacherFromCourse < ActiveRecord::Migration[5.0]
  def change
    remove_column :courses, :teacher_id
  end
end
