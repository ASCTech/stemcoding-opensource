# frozen_string_literal: true

class IndexSubmissionsOnUserId < ActiveRecord::Migration[5.2]
  def change
    add_index :submissions, :user_id
  end
end
