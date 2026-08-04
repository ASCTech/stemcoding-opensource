# frozen_string_literal: true

class Teacher::SubmissionPolicy < TeacherPolicy
  class Scope < Scope
    def resolve
      scope.none
    end
  end

  def show?
    teacher_owns_submission?
  end

  def update?
    teacher_owns_submission?
  end

  def permitted_attributes
    %i[
      instructor_comment
      grade
    ]
  end

  private

    def submission
      record
    end

    def user_instructs_student?
      submission.author_taught_by?(user)
    end

    def user_instructor_for_lab?
      submission.lab_taught_by?(user)
    end

    def teacher_owns_submission?
      user_instructs_student? && user_instructor_for_lab?
    end
end
