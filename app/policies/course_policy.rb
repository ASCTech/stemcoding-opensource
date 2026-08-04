# frozen_string_literal: true

class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.none
    end
  end

  private

    def course
      record
    end
end
