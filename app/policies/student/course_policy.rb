# frozen_string_literal: true

class Student::CoursePolicy < StudentPolicy
  class Scope < Scope
    def resolve
      student? ? scope.enrolls(user) : scope.none
    end
  end

  def show?
    user.enrolled_in_course?(course)
  end

  private

    def course
      record
    end
end
