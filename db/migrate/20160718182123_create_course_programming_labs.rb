# frozen_string_literal: true

# This creates a course programming lab linking a course and a programming lab
# together.
class CreateCourseProgrammingLabs < ActiveRecord::Migration[4.2]
  def change
    create_table :course_programming_labs do |t|
      t.integer "course_id", null: false
      t.integer "programming_lab_id", null: false
      t.timestamps null: false
    end

    add_index :course_programming_labs,
              [:course_id, :programming_lab_id],
              unique: true,
              name: "index_course_programming_labs_on_course_lab_id"
  end
end
