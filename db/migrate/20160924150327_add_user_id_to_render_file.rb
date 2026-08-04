# frozen_string_literal: true

# This is used to make sure that render files are only accessed by the appropriate
# user.
class AddUserIdToRenderFile < ActiveRecord::Migration[4.2]
  def change
    add_column :render_files, :user_id, :integer, null: false
  end
end
