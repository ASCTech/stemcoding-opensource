require "rails_helper"

describe "Student enrollments", js: true do
  context "when students have a join key" do
    it "allows them to enroll in a course" do
      course = create(:course)
      join_key = course.join_key
      student = create(:student)

      login_as student

      click_on "Join a course"
      fill_in "Enter your course's join key:", with: join_key
      click_on "Join course"

      expect(find(".alert-notice")).to have_content("You have enrolled in #{course.title}")
    end
  end
end
