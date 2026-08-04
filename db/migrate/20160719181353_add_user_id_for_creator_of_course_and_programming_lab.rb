# frozen_string_literal: true

# This adds the initial creator id flag to programming_labs and courses. This
# is later renamed to be creator_id.
class AddUserIdForCreatorOfCourseAndProgrammingLab < ActiveRecord::Migration[4.2]
  def change
    add_column :programming_labs, :user_id, :integer, null: false
    add_column :courses, :user_id, :integer, null: false
  end
end
