# frozen_string_literal: true

# This creates the table submission_files and adds several columns to this
# table.
class CreateSubmissionFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :submission_files do |t|
      t.integer :submission_id, null: false
      t.string :file, null: false
      t.timestamps null: false
    end
  end
end
