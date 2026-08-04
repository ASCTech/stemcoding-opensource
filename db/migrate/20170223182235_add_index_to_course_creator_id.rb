# frozen_string_literal: true

class AddIndexToCourseCreatorId < ActiveRecord::Migration[5.0]
  def change
    add_index :courses, :creator_id
  end
end
