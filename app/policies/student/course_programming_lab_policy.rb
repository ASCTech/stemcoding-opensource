class Student::CourseProgrammingLabPolicy < CourseProgrammingLabPolicy
  class Scope < Scope
    def resolve
      scope.enrolls(user).submittable
    end
  end

  def index?
    student?
  end

  def show?
    user_enrolled_in_lab?
  end

  private

    def course_lab
      record
    end

    def user_enrolled_in_lab?
      user.enrolled_in_lab?(programming_lab)
    end
end
