require "rails_helper"

describe "Student course labs", js: true do
  let(:enrollment) { create(:enrollment) }
  let!(:course_lab) { create(:submittable_course_lab, course: enrollment.course) }

  describe "viewing all submissions" do
    before :each do
      login_as enrollment.student
      click_on course_lab.lab_title
      click_on "View Submissions"
    end
  end
end
