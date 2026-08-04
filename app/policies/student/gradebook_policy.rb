# frozen_string_literal: true

class Student::GradebookPolicy < StudentPolicy
  def show?
    student?
  end
end
