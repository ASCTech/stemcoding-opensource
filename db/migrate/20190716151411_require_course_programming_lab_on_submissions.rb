class RequireCourseProgrammingLabOnSubmissions < ActiveRecord::Migration[6.0]
  def change
    change_column_null :submissions, :course_programming_lab_id, false
  end
end
