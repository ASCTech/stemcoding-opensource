# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/submission_mailer
class SubmissionMailerPreview < ApplicationMailerPreview
  def notify_author_of_grade
    SubmissionMailer.with(submission: submission).notify_author_of_grade
  end

  def notify_author_of_instructor_comment
    SubmissionMailer.with(submission: submission).notify_author_of_instructor_comment
  end


  private

    def course_lab
      instance_double(
        CourseProgrammingLab,
        title: "Course title: Lab title",
        to_param: 1,
      )
    end

    def submission
      object_double(
        Submission.new,
        course_programming_lab: course_lab,
        author_email: "author@email.com",
        author_full_name: "Author full name",
        instructor_comment: "Instructor Comment",
        to_param: 1,
      )
    end
end
