class Teacher::CourseAssignmentPolicy < TeacherPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user_teaches_courses?
  end

  def new?
    create?
  end

  def permitted_attributes
    [
      courses: [],
    ]
  end

  private

    def course_assignment
      record
    end

    def courses
      course_assignment.courses
    end

    def user_teaches_courses?
      courses.all? { |c| c.taught_by?(user) }
    end
end
