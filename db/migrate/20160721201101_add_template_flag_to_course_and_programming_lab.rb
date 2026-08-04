# frozen_string_literal: true

# Thi smigration adds a template flag to course and programming lab.
class AddTemplateFlagToCourseAndProgrammingLab < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :template, :boolean, null: false, default: false
    add_column :programming_labs, :template, :boolean, null: false, default: false
  end
end
