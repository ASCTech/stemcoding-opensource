# frozen_string_literal: true

class StudentsController < ApplicationController
  protected

    def policy_scope(scope)
      super([:student, scope])
    end

    def authorize(record, query = nil)
      super([:student, record], query)
    end

    def permitted_attributes(record)
      super([:student, record])
    end
end
