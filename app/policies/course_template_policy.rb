# frozen_string_literal: true

class CourseTemplatePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.none
    end
  end
end
