class AddSubmittableToCourseProgrammingLabs < ActiveRecord::Migration[6.0]
  def change
    add_column :course_programming_labs, :submittable, :boolean, default: false, null: false
  end
end
