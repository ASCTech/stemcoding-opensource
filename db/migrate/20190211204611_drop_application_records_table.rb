# frozen_string_literal: true

class DropApplicationRecordsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :application_records
  end
end
