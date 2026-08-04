# frozen_string_literal: true

class Student::ProgrammingLabFilePolicy < StudentPolicy
  def show?
    student_file? && downloadable_file?
  end

  private

    def lab_file
      record
    end

    def student_file?
      lab_file.lab_enrolls_student?(user)
    end

    def downloadable_file?
      lab_file.downloadable?
    end
end
