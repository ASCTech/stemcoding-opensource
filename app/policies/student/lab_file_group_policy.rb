# frozen_string_literal: true

class Student::LabFileGroupPolicy < StudentPolicy
  def show?
    admin? || student_enrolled_in_lab?
  end

  private

    def lab_file_group
      record
    end

    def student_enrolled_in_lab?
      lab_file_group.lab_enrolls_student?(user)
    end
end
