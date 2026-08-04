# frozen_string_literal: true

class ProgrammingLabPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.none
    end
  end
end
