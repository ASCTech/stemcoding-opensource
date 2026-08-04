# frozen_string_literal: true

# This creates the submission table.
class CreateSubmissions < ActiveRecord::Migration[4.2]
  def change
    create_table :submissions do |t|
      t.references :user, foreign_key: true, null: false
      t.references :submission, foreign_key: :parent_submission_id
      t.timestamps null: false
    end
  end
end
