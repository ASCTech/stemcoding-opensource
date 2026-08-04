# frozen_string_literal: true

class CodeProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.code_projects.order(updated_at: :desc)
    end
  end

  def index?
    true
  end

  def show?
    user_project?
  end

  def create?
    true
  end

  def destroy?
    user_project?
  end

  def submit?
    user_project?
  end

  def submit_pass?
    user_project?
  end

  def permitted_attributes
    %i[
      name
      description
    ]
  end

  private

    def code_project
      record
    end

    def user_project?
      code_project.owned_by?(user)
    end
end
