# frozen_string_literal: true

# This adds the question_id column to a choice.
class AddChoiceToQuestionAssociation < ActiveRecord::Migration[4.2]
  def change
    add_column :choices, :question_id, :integer, null: false if table_exists?(:choices)
  end
end
