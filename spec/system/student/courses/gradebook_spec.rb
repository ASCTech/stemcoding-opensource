require "rails_helper"

describe "Student course gradebook", js: true do
  context "when viewed by a student" do
    it "does something" do
      enrollment = create(:enrollment)
      course = enrollment.course
      create(:programming_lab, courses: [course])
      student = enrollment.student

      login_as student

      click_on course.title
      click_on "Gradebook"
    end
  end
end
