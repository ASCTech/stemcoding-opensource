# frozen_string_literal: true

class Teacher::CourseTemplatePolicy < TeacherPolicy
  class Scope < Scope
    def resolve
      super_teacher? || teacher? ? scope.is_template : scope.none
    end
  end

  def show?
    (super_teacher? || teacher?) && course.template?
  end

  def create?
    super_teacher? || teacher?
  end

  private

    def course
      record
    end
end
