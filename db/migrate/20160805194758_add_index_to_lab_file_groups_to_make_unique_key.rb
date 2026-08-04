# frozen_string_literal: true

# This adds the index to the LabFileGroups
class AddIndexToLabFileGroupsToMakeUniqueKey < ActiveRecord::Migration[4.2]
  def change
    add_index :lab_file_groups,
              [:programming_lab_id, :key],
              unique: true
  end
end
