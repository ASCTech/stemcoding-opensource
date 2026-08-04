# frozen_string_literal: true

# Creates the LabFileGroup table.
class CreateLabFileGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :lab_file_groups do |t|
      t.timestamps null: false
      t.boolean :downloadable, null: false, default: false
      t.string :key, null: false
      t.integer :programming_lab_id, null: false
    end
  end
end
