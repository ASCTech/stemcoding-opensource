# frozen_string_literal: true

class CreateCodeProjectFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :code_project_files do |t|
      t.timestamps
      t.integer :code_project_id, null: false
      t.string :name, null: false
      t.text :content, null: false
    end
  end
end
