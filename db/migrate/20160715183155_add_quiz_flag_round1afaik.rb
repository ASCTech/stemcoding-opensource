# frozen_string_literal: true

# Adds the title field and the randomize_order flag to quizzes. I really did
# do terribly at naming my migrations at this early stage.
class AddQuizFlagRound1afaik < ActiveRecord::Migration[4.2]
  def change
    if table_exists?(:quizzes)
      add_column(:quizzes, :title, :string, null: false)
      add_column(:quizzes, :randomize_order, :boolean, null: false, default: false)
    end
  end
end
