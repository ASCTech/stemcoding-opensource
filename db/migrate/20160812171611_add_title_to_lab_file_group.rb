# frozen_string_literal: true

# Adds a title filed to the lab file group.
class AddTitleToLabFileGroup < ActiveRecord::Migration[4.2]
  def change
    add_column :lab_file_groups, :title, :string, null: false
  end
end
