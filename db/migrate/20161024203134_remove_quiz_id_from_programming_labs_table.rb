# frozen_string_literal: true

class RemoveQuizIdFromProgrammingLabsTable < ActiveRecord::Migration[4.2]
  def change
    remove_column :programming_labs, :quiz_id
  end
end
