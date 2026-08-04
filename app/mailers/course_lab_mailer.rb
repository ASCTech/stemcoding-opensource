class CourseLabMailer < ApplicationMailer
  def notify_students_of_status
    @course_lab = params.fetch(:course_lab)
    @student_emails = @course_lab.student_emails

    @submittable = @course_lab.submittable?
    subject = @course_lab.submittable? ? "Students can submit work to #{@course_lab.title}" : "Students can no longer submit work to #{@course_lab.title}"

    mail(bcc: @student_emails, subject: subject)
  end
end
