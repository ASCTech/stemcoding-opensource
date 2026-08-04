# frozen_string_literal: true

class SubmissionFilePolicy < ApplicationPolicy
  def show?
    admin? ||
      lab_authored_by_user? ||
      lab_enrolls_student? ||
      lab_taught_by_user?
  end

  private

    def lab_file
      record
    end

    def lab_enrolls_student?
      lab_file.lab_enrolls_student?(user)
    end

    def lab_taught_by_user?
      lab_file.lab_taught_by?(user)
    end

    def lab_authored_by_user?
      lab_file.lab_authored_by?(user)
    end
end
