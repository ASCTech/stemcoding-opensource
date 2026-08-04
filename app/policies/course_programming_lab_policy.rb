class CourseProgrammingLabPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      namespace =
        if admin? then Admin
        elsif super_teacher? || teacher? then Teacher
        else Student
        end

      namespace::CourseProgrammingLabPolicy::Scope.new(user, scope).resolve
    end
  end

  protected

    def course_lab
      record
    end

    def course
      course_lab.course
    end

    def programming_lab
      course_lab.programming_lab
    end
end
