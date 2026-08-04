class AddCourseTeachersCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :course_teachers_count, :integer, null: false, default: 0
  end
end
