# frozen_string_literal: true

class AddUsersForeignKeyToRenderFile < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :render_files, :users, on_delete: :nullify
  end
end
