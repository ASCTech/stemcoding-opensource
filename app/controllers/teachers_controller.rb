# frozen_string_literal: true

class TeachersController < ApplicationController
  protected

    def policy_scope(scope)
      super([:teacher, scope])
    end

    def authorize(record, query = nil)
      super([:teacher, record], query)
    end

    def permitted_attributes(record)
      super([:teacher, record])
    end
end
