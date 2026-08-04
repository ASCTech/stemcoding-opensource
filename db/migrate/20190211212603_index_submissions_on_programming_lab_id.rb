# frozen_string_literal: true

class IndexSubmissionsOnProgrammingLabId < ActiveRecord::Migration[5.2]
  def change
    add_index :submissions, :programming_lab_id
  end
end
