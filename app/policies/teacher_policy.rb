class TeacherPolicy < ApplicationPolicy
  def index?
    super_teacher? || teacher?
  end
end
