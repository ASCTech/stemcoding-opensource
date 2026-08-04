# frozen_string_literal: true

class Teacher::UserPolicy < TeacherPolicy
  class Scope < Scope
    def resolve
      scope.none
    end
  end

  def show?
    student_taught_by_user?
  end

  private

    def student
      record
    end

    def student_taught_by_user?
      student.taught_by?(user)
    end
end
