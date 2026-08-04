# frozen_string_literal: true

# This allows the programming_lab_id to be null in quizzes.
#
# This has since been removed and replaced with a foreign_key in the
# programming lab object.
# The new relationship is a programming lab belongs to quiz, and quiz has_many
# programming labs.
class AllowQuizProgrammingLabIdToBeNull < ActiveRecord::Migration[4.2]
  def change
    change_column_null(:quizzes, :programming_lab_id, true) if table_exists?(:quizzes)
  end
end
