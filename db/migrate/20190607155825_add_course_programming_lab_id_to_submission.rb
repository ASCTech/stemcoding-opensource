class AddCourseProgrammingLabIdToSubmission < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :course_programming_lab_id, :integer
    add_index :submissions, :course_programming_lab_id
    add_foreign_key :submissions, :course_programming_labs
  end
end
