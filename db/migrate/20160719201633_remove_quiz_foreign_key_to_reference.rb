# frozen_string_literal: true

class RemoveQuizForeignKeyToReference < ActiveRecord::Migration[4.2]
  def change
    remove_column :quizzes, :programming_lab_id if table_exists?(:quizzes)
  end
end
