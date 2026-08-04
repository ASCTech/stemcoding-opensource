# frozen_string_literal: true

# This clarifies what the "user_id" in quizzes means, as it is actually the id
# of the user which was the creator.
class ChangeUserIdToCreatorIdInQuiz < ActiveRecord::Migration[4.2]
  def change
    rename_column :quizzes, :user_id, :creator_id if table_exists?(:quizzes)
  end
end
