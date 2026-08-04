# frozen_string_literal: true

class AddProgrammingLabsForeignKeyToCourseProgrammingLabs < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :course_programming_labs, :programming_labs
  end
end
