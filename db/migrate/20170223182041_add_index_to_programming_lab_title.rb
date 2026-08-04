# frozen_string_literal: true

class AddIndexToProgrammingLabTitle < ActiveRecord::Migration[5.0]
  def change
    add_index :programming_labs, :title
  end
end
