# frozen_string_literal: true

class AddLabFileGroupsForeignKeyToProgrammingLabFiles < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :programming_lab_files, :lab_file_groups
  end
end
