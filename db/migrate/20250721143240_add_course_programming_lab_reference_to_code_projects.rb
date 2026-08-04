class AddCourseProgrammingLabReferenceToCodeProjects < ActiveRecord::Migration[7.2]
  def change
    add_reference :code_projects, :course_programming_lab, index: false, default: nil
  end
end
