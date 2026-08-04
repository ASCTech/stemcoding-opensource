# frozen_string_literal: true

# This adds a user_id to represent the creator of the quiz.
#
# This was later renamed to creator_id
class AddUseridToQuiz < ActiveRecord::Migration[4.2]
  def change
    add_column :quizzes, :user_id, :integer, null: false if table_exists?(:quizzes)
  end
end
