# frozen_string_literal: true

class Student::UserPolicy < StudentPolicy
  class Scope < Scope
    def resolve
      scope.none
    end
  end

  def show?
    false
  end
end
