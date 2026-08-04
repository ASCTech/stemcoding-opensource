# frozen_string_literal: true

# Add a file name to the render file.
class AddFileNameToRenderFile < ActiveRecord::Migration[4.2]
  def change
    add_column :render_files, :name, :string, null: false
  end
end
