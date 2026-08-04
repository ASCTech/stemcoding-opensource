# frozen_string_literal: true

# This is utilized to change submissions programming_lab_id to not be nullable
# in accordance with https://www.pivotaltracker.com/story/show/127273389
# Finally got around to doing this.
class ChangeProgrammingLabIdOnSubmissionsToNotNullable < ActiveRecord::Migration[4.2]
  def change
    change_column_null(:submissions, :programming_lab_id, false)
  end
end
