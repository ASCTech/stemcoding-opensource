# frozen_string_literal: true

# This fills out the columns for both quizzes and for questions.
class AddRelativeScoring < ActiveRecord::Migration[4.2]
  def change
    add_column :quizzes, :total_score, :float, null: false if table_exists?(:quizzes)

    if table_exists?(:questions)
      add_column :questions, :content, :text, null: false
      add_column :questions, :weight, :float, null: false, default: 1.0
      add_column :questions, :randomize_order, :boolean, null: false, default: false
    end
  end
end
