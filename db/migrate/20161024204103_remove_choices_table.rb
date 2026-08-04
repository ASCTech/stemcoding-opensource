# frozen_string_literal: true

class RemoveChoicesTable < ActiveRecord::Migration[4.2]
  def change
    drop_table :choices if table_exists?(:choices)
  end
end
