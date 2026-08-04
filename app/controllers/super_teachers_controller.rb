# frozen_string_literal: true

class SuperTeachersController < ApplicationController
  protected

    def policy_scope(scope)
      super([:super_teacher, scope])
    end

    def authorize(record, query = nil)
      super([:super_teacher, record], query)
    end

    def permitted_attributes(record)
      super([:super_teacher, record])
    end
end
