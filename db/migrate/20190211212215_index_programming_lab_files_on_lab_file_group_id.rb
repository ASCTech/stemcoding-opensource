# frozen_string_literal: true

class IndexProgrammingLabFilesOnLabFileGroupId < ActiveRecord::Migration[5.2]
  def change
    add_index :programming_lab_files, :lab_file_group_id
  end
end
