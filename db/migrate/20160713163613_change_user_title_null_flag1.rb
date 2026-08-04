# frozen_string_literal: true

# This allows the title of a user to be null.
#
# For some reason I had it set to null: false when this column was initially
# created. Hmm.... Oh well, now it is fixed :)
class ChangeUserTitleNullFlag1 < ActiveRecord::Migration[4.2]
  def change
    change_column_null(:users, :title, true)
  end
end
