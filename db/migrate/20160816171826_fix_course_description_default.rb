# frozen_string_literal: true

# This fixes the default course description to be blank
class FixCourseDescriptionDefault < ActiveRecord::Migration[4.2]
  def change
    change_column :courses, :description, :text, null: false, default: ""
  end
end
