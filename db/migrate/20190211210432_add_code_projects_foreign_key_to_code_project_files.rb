# frozen_string_literal: true

class AddCodeProjectsForeignKeyToCodeProjectFiles < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :code_project_files, :code_projects
  end
end
