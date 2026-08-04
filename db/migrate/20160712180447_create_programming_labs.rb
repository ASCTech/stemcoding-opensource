# frozen_string_literal: true

# This creates the table programming_labs.
class CreateProgrammingLabs < ActiveRecord::Migration[4.2]
  def change
    create_table :programming_labs do |t|
      t.timestamps null: false
    end
  end
end
