# frozen_string_literal: true

# This sets quiz_id field in a programming_lab to be nullable.
# (Allowing for a quiz to not be required in a programming lab.)
class AllowQuizIdToBeFalseInProgrammingLabs < ActiveRecord::Migration[4.2]
  def change
    change_column_null(:programming_labs, :quiz_id, true)
  end
end
