# frozen_string_literal: true

class Student::ProgrammingLabPolicy < StudentPolicy
  class Scope < Scope
    def resolve
      scope.enrolls(user)
    end
  end

  def show?
    admin? || user_enrolled_in_lab?
  end

  private

    def programming_lab
      record
    end

    def user_enrolled_in_lab?
      user.enrolled_in_lab?(programming_lab)
    end
end
