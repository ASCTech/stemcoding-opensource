# frozen_string_literal: true

# This adds the fields of title and description to a course. No idea why I did
# a banged-on-keyboard-name for it.
class AddCourseColumnsAsfiawejof < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :title, :string, null: false
    add_column :courses, :description, :text, null: false, default: "Default course description"
  end
end
