# frozen_string_literal: true

# This adds the quiz id column to the programming_labs table.
class AddProgrammingLabQuizId < ActiveRecord::Migration[4.2]
  def change
    add_column :programming_labs, :quiz_id, :integer, null: false
  end
end
