require "rails_helper"

describe "Student course lab submissions", js: true do
  let(:enrollment) { create(:enrollment) }
  let(:course_lab) { create(:submittable_course_lab, course: enrollment.course) }

  let(:submission_page) do
    Page::Student::Submission.new(
      enrollment: enrollment,
      course_programming_lab: course_lab,
      student_comment: "Student comment"
    )
  end

  describe "creation" do
    before :each do
      course_lab

      login_as enrollment.student

      submission_page.create
    end

    it "displays success notification" do
      expect(submission_page).to have_success_notification
    end

    describe "then viewing the submission" do
      before :each do
        submission_page.view
      end

      it "has student's comments" do
        expect(submission_page).to have_student_comment
      end
    end
  end
end
