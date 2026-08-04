# frozen_string_literal: true

class AddProgrammingLabForeignKeyToSubmission < ActiveRecord::Migration[4.2]
  def change
    add_column :submissions, :programming_lab_id, :integer
  end
end
