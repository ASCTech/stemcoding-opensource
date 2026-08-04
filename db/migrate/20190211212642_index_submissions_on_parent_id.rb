# frozen_string_literal: true

class IndexSubmissionsOnParentId < ActiveRecord::Migration[5.2]
  def change
    add_index :submissions, :parent_id
  end
end
