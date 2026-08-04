# frozen_string_literal: true

class Teacher::DashboardPolicy < TeacherPolicy
  def show?
    super_teacher? || teacher?
  end
end
