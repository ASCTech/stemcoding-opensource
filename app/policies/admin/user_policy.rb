# frozen_string_literal: true

class Admin::UserPolicy < AdminPolicy
  class Scope < Scope
    def resolve
      admin? ? scope.all : scope.none
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
      :admin,
      :super_teacher,
      :teacher,
      :student,
      { enrolled_course_ids: [] },
    ]
  end
end
