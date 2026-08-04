# frozen_string_literal: true

class IndexCodeProjectsOnUserId < ActiveRecord::Migration[5.2]
  def change
    add_index :code_projects, :user_id
  end
end
