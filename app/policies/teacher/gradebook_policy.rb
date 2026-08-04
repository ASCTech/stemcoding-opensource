# frozen_string_literal: true

class Teacher::GradebookPolicy < TeacherPolicy
  def show?
    super_teacher? || teacher? || admin?
  end
end
