# frozen_string_literal: true

class Student::SubmissionPolicy < StudentPolicy
  class Scope < Scope
    def resolve
      student? ? scope.authored_by(user.enrollments) : scope.none
    end
  end

  def show?
    student_in_lab_and_authored_submission?
  end

  def create?
    student_in_lab? && submission.submittable?
  end

  def update?
    create?
  end

  def permitted_attributes
    [
      :student_comment,
      files_attributes: %i[
        id
        file
        downloadable
        display
        _destroy
      ],
    ]
  end

  private

    def submission
      record
    end

    def student_in_lab?
      submission.lab_enrolls_student?(user)
    end

    def student_authored_submission?
      submission.authored_by?(user)
    end

    def student_in_lab_and_authored_submission?
      student_in_lab? && student_authored_submission?
    end
end
