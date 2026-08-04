# frozen_string_literal: true

# This goes and removes the access flags from programming_lab_files
class RemoveProgrammingLabFileAccessFlags < ActiveRecord::Migration[4.2]
  def change
    remove_column :programming_lab_files, :downloadable
    remove_column :programming_lab_files, :display
  end
end
