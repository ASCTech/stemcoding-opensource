class AddPositionToCourseProgrammingLab < ActiveRecord::Migration[6.0]
  def change
    add_column :course_programming_labs, :position, :integer
    add_index :course_programming_labs, %i[course_id position]
  end
end
