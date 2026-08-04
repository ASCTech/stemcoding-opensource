# Preview all emails at http://localhost:3000/rails/mailers/course_lab
class CourseLabMailerPreview < ApplicationMailerPreview
  def notify_students_of_open_submission_status
    course_lab = course_lab(submittable: true)

    CourseLabMailer.with(course_lab: course_lab).notify_students_of_status
  end

  def notify_students_of_closed_submission_status
    course_lab = course_lab(submittable: false)

    CourseLabMailer.with(course_lab: course_lab).notify_students_of_status
  end

  private

    def course_lab(submittable:)
      object_double(
        CourseProgrammingLab.new,
        submittable?: submittable,
        course_title: "Course Title",
        lab_title: "Lab Title",
        title: "Course Title: Lab Title",
        student_emails: ["student@example.com"],
        to_model: CourseProgrammingLab.new,
        id: 1
      )
    end
end
