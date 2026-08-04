# frozen_string_literal: true

class AddProgrammingLabForeignKeyToLabFileGroups < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :lab_file_groups, :programming_labs, on_delete: :cascade
  end
end
