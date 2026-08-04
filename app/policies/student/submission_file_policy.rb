# frozen_string_literal: true

class Student::SubmissionFilePolicy < StudentPolicy
  def show?
    student_file?
  end

  private

    def submission_file
      record
    end

    def student_file?
      submission_file.submission_authored_by?(user)
    end
end
