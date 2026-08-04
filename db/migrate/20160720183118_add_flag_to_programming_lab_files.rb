# frozen_string_literal: true

# This adds the downloadable and display flags to the programming_lab_files.
#
# This functionality was moved to LabFileGroup and removed from this table.
class AddFlagToProgrammingLabFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :programming_lab_files, :downloadable, :boolean, null: false, default: false
    add_column :programming_lab_files, :display, :boolean, null: false, default: false
  end
end
