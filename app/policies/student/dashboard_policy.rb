# frozen_string_literal: true

class Student::DashboardPolicy < StudentPolicy
  def show?
    student?
  end
end
