# frozen_string_literal: true

class IndexCodeProjectFilesOnCodeProjectId < ActiveRecord::Migration[5.2]
  def change
    add_index :code_project_files, :code_project_id
  end
end
