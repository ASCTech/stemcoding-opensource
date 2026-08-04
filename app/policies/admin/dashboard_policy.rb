# frozen_string_literal: true

class Admin::DashboardPolicy < AdminPolicy
  def show?
    admin?
  end
end
