# Preview all emails at http://localhost:3000/rails/mailers/user
class UserMailerPreview < ActionMailer::Preview
  def last_weeks_taught_submissions
    course_teacher = FactoryBot.create(:course_teacher)
    teacher = course_teacher.teacher
    course = course_teacher.course

    course_labs = FactoryBot.create_list(:course_lab, 3, course: course)
    course_labs.flat_map { |course_lab| FactoryBot.create_list(:submission, 3, course_programming_lab: course_lab) }

    UserMailer.with(user: teacher).last_weeks_taught_submissions
  end
end
