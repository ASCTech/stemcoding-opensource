# frozen_string_literal: true

# This migration switches to the grouped system for programming lab file.
class ChangeOwnershipOfProgrammingLabFile < ActiveRecord::Migration[4.2]
  def change
    remove_column :programming_lab_files, :programming_lab_id
    add_column :programming_lab_files, :lab_file_group_id, :integer, null: false
  end
end
