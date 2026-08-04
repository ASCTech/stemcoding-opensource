# frozen_string_literal: true

class Admin::CoursePolicy < AdminPolicy
  class Scope < Scope
    def resolve
      admin? ? scope.all.order(updated_at: :desc) : scope.none
    end
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def permitted_attributes
    [
      :title,
      :description,
      :template,
      :join_key,
      programming_lab_ids: [],
      teacher_ids: [],
    ]
  end
end
