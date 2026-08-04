# frozen_string_literal: true

# This adds a comment field for both student and instructor comments to a
# submission. These fields are of type text.
class AddCommentToSubmission < ActiveRecord::Migration[4.2]
  def change
    add_column :submissions, :student_comment, :text
    add_column :submissions, :instructor_comment, :text
  end
end
