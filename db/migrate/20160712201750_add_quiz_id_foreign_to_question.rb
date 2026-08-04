# frozen_string_literal: true

# This adds the quiz_id foreign key to the questions table.
class AddQuizIdForeignToQuestion < ActiveRecord::Migration[4.2]
  def change
    add_column :questions, :quiz_id, :integer, null: false if table_exists?(:questions)
  end
end
