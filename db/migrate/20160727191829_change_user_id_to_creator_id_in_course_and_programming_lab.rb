# frozen_string_literal: true

# This migration changes the user id to creator id for course and programming
# lab.
class ChangeUserIdToCreatorIdInCourseAndProgrammingLab < ActiveRecord::Migration[4.2]
  def change
    rename_column :courses, :user_id, :creator_id
    rename_column :programming_labs, :user_id, :creator_id
  end
end
