# frozen_string_literal: true

# Adds a column to the user table that indicates when they were last active.
# This is updated using a before action in the ApplicationController.
class AddLastActiveAtToUserColumn < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :last_active_at, :datetime
  end
end
