class StudentPolicy < ApplicationPolicy
  def index?
    student?
  end
end
