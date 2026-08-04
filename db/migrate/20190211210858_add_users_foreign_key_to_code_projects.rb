# frozen_string_literal: true

class AddUsersForeignKeyToCodeProjects < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :code_projects, :users
  end
end
