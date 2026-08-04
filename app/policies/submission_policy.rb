# frozen_string_literal: true

class SubmissionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.none
    end
  end

  def create?
    Student::SubmissionPolicy.new(user, submission).create? ||
      Teacher::SubmissionPolicy.new(user, submission).create? ||
      Admin::SubmissionPolicy.new(user, submission).create?
  end

  def update?
    create?
  end

  def permitted_attributes
    [
      :student_comment,
      :course_programming_lab_id,
    ]
  end

  private

    def submission
      record
    end
end
