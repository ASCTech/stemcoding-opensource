# frozen_string_literal: true

class P5FileInlinePolicy < ApplicationPolicy
  def show?
    lab_enrolls_student? ||
      lab_taught_by_user? ||
      admin? ||
      super_teacher?
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
end
