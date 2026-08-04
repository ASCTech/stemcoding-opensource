# frozen_string_literal: true

# This ensures that the submission comment is not null, and defaults to ""
class FixSubmissionsComment < ActiveRecord::Migration[4.2]
  def change
    change_column :submissions, :student_comment, :text, null: false, default: ""
    change_column :submissions, :instructor_comment, :text, null: false, default: ""
  end
end
