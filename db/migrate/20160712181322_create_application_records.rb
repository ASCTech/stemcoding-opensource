# frozen_string_literal: true

# This creates the application_records table.
class CreateApplicationRecords < ActiveRecord::Migration[4.2]
  def change
    create_table :application_records do |t|
      t.timestamps null: false
    end
  end
end
