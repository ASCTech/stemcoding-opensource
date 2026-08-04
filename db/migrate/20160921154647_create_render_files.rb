# frozen_string_literal: true

# This migration handles creating the RenderFile model's ActiveRecord DB Table.
class CreateRenderFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :render_files do |t|
      t.timestamps null: false
      t.datetime :expires, null: false
      t.text :content, null: false
    end
  end
end
