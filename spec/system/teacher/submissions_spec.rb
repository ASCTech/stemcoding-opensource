require "rails_helper"

describe "Submissions", js: true do
  include ActiveSupport::Testing::TimeHelpers

  describe "viewed by a teacher" do
    it "allows them to see previous submissions" do
      course_lab = create(:course_lab)
      enrollment = create(:enrollment, course: course_lab.course)
      teacher = create(:course_teacher, course: course_lab.course).teacher

      travel_to 3.days.ago
      first_submission = create(:graded_submission, course_programming_lab: course_lab, author: enrollment)
      travel_to 1.day.from_now
      second_submission = create(:graded_submission, course_programming_lab: course_lab, author: enrollment)
      travel_to 1.day.from_now
      create(:ungraded_submission, course_programming_lab: course_lab, author: enrollment)
      travel_back

      login_as teacher

      click_on "Gradebook"
      click_on "Not graded"

      previous_submissions = find("#previous-submissions")

      expect(previous_submissions).to have_content(first_submission.chain_index)
      expect(previous_submissions).to have_content(second_submission.chain_index)
    end
  end
end
