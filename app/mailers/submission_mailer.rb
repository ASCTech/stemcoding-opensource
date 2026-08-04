class SubmissionMailer < ApplicationMailer
  def notify_author_of_grade
    @submission = params.fetch(:submission)

    @to = @submission.author_email
    @course_lab = @submission.course_programming_lab

    @subject = "#{@course_lab.title} - Your submission has been graded."

    mail to: @to, subject: @subject
  end

  def notify_author_of_instructor_comment
    @submission = params.fetch(:submission)
    @to = @submission.author_email
    @course_lab = @submission.course_programming_lab

    @subject = "#{@course_lab.title} - An instructor has commented on your submission"

    mail to: @to, subject: @subject
  end
end
