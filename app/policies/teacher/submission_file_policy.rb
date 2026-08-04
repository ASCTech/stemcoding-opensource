# frozen_string_literal: true

class Teacher::SubmissionFilePolicy < TeacherPolicy
  def show?
    lab_taught_by_user? || super_teacher?
  end

  private

    def submission_file
      record
    end

    def lab_taught_by_user?
      submission_file.lab_taught_by?(user)
    end
end
