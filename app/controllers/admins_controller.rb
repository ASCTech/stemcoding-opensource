# frozen_string_literal: true

class AdminsController < ApplicationController
  protected

    def policy_scope(scope)
      super([:admin, scope])
    end

    def authorize(record, query = nil)
      super([:admin, record], query)
    end

    def permitted_attributes(record)
      super([:admin, record])
    end
end
