class RequirePositionOnCourseLabs < ActiveRecord::Migration[6.0]
  def change
    change_column_null :course_programming_labs, :position, false
  end
end
