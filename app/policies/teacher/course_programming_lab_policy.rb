class Teacher::CourseProgrammingLabPolicy < CourseProgrammingLabPolicy
  class Scope < Scope
    def resolve
      scope.taught_or_course_created_by(user)
    end
  end

  def index?
    super_teacher? || teacher?
  end

  def update?
    super_teacher? || teacher?
  end

  def permitted_attributes
    if super_teacher? || teacher?
      %i[submittable]
    else
      []
    end
  end
end
