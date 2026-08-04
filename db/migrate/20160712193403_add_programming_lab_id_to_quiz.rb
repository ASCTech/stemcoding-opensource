# frozen_string_literal: true

# This adds the programming lab id to quizzes.
#
# This has since been removed in favor of storing the key in the
# programming_labs table.
class AddProgrammingLabIdToQuiz < ActiveRecord::Migration[4.2]
  def change
    add_column :quizzes, :programming_lab_id, :integer, null: false if table_exists?(:quizzes)
  end
end
