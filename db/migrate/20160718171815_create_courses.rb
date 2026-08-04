# frozen_string_literal: true

# This creates the table courses.
class CreateCourses < ActiveRecord::Migration[4.2]
  def change
    create_table :courses do |t|
      t.timestamps null: false
    end
  end
end
