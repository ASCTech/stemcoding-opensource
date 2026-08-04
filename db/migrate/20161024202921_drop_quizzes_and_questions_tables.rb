# frozen_string_literal: true

class DropQuizzesAndQuestionsTables < ActiveRecord::Migration[4.2]
  def change
    drop_table :questions if table_exists?(:questions)
    drop_table :quizzes if table_exists?(:quizzes)
  end
end
