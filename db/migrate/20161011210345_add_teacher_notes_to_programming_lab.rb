# frozen_string_literal: true

# This adds a text column `teacher_notes` to the programming lab table.
# This is used to go and allow teachers to see notes from an admin on how they
# should go about teaching the lab.
class AddTeacherNotesToProgrammingLab < ActiveRecord::Migration[4.2]
  def change
    add_column :programming_labs, :teacher_notes, :text, null: true
  end
end
