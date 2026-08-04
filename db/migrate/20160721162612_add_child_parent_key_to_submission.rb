# frozen_string_literal: true

# This adds the columns necessary to link a child submission to its parent via
# a has_one/belongs_to relationship.
class AddChildParentKeyToSubmission < ActiveRecord::Migration[4.2]
  def change
    remove_column :submissions, :submission_id
    add_column :submissions, :parent_id, :integer, null: true
  end
end
