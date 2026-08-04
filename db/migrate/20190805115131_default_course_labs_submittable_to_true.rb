class DefaultCourseLabsSubmittableToTrue < ActiveRecord::Migration[6.0]
  def change
    change_column_default :course_programming_labs, :submittable, true
  end
end
