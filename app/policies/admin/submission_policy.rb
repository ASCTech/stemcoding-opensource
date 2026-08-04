# frozen_string_literal: true

class Admin::SubmissionPolicy < AdminPolicy
  class Scope < Scope
    def resolve
      scope.none
    end
  end
end
