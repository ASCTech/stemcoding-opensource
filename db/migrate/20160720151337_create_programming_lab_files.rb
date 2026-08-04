# frozen_string_literal: true

# This creates a migration that creates the tablet o store the data of the
# programming lab files.
class CreateProgrammingLabFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :programming_lab_files do |t|
      t.integer :programming_lab_id, null: false
      t.string :file, null: false
      t.timestamps null: false
    end
  end
end
