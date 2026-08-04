# frozen_string_literal: true

# This adds a grade column to a submission of type float.
class AddGradeToSubmission < ActiveRecord::Migration[4.2]
  def change
    add_column :submissions, :grade, :float, null: true
  end
end
