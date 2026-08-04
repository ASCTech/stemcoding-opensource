class AddCourseProgrammingLabsCountToCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :course_programming_labs_count, :integer, default: 0, null: false
  end
end
