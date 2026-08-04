# frozen_string_literal: true

class ProgrammingLabFilePolicy < ApplicationPolicy
  def show?
    user_enrolled_in_lab? ||
      lab_taught_by_user? ||
      lab_authored_by_user? ||
      admin?
  end

  private

    def lab_file
      record
    end

    def user_enrolled_in_lab?
      lab_file.lab_enrolls_student?(user)
    end

    def lab_taught_by_user?
      lab_file.lab_taught_by?(user)
    end

    def lab_authored_by_user?
      lab_file.lab_authored_by?(user)
    end
end
