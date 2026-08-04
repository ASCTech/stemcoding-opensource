# frozen_string_literal: true

class Teacher::CoursePolicy < TeacherPolicy
  class Scope < Scope
    def resolve
      scope.is_not_template.taught_or_created_by(user)
    end
  end

  def show?
    course.taught_or_created_by?(user) || course.template? || admin?
  end

  def create?
    teacher? || super_teacher?
  end

  def update?
    course.taught_or_created_by?(user)
  end

  def destroy?
    course.taught_or_created_by?(user) && !course.has_submissions?
  end

  def permitted_attributes
    [
      :title,
      :description,
      :join_key,
      programming_lab_ids: [],
      teacher_ids: [],
      course_programming_labs_attributes: %i[id position _destroy],
    ]
  end

  private

    def course
      record
    end
end
