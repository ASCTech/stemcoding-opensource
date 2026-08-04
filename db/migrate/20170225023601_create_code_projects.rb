# frozen_string_literal: true

class CreateCodeProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :code_projects do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.text :description, null: false, default: ""
      t.timestamps
    end
  end
end
