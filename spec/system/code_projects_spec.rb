# frozen_string_literal: true

require "rails_helper"

describe "Code projects", js: true do
  context "when submitting a course lab as a student" do
    let(:course) { create(:course) }
    let(:submittable_course_labs) { create_list(:submittable_course_lab, 3, course: course) }
    let(:chosen_course_lab) { submittable_course_labs.sample }
    let(:closed_course_labs) { create_list(:closed_course_lab, 3, course: course) }
    let(:enrollments) { create_list(:enrollment, 5, course: course) }
    let(:enrollment) { enrollments.sample }

    before(:each) do
      chosen_course_lab
      closed_course_labs

      login_as(enrollment.student)

      click_on "Sandbox"
      # The student "Save Project" button opens the form in a new window.
      new_window = window_opened_by { find("#save-project").click wait: 10 }
      switch_to_window(new_window)
      fill_in "Project name", with: "Project name"
      click_on "Save Project"
      click_on "Submit"
      choose chosen_course_lab.title
      fill_in "Comments", with: "Student comment"
      click_on "Submit Project"
    end

    it "notifies the student that they have successfully submitted a lab" do
      expect(find(".alert-notice")).to have_content("Code project submitted for programming lab, #{chosen_course_lab.title}")
    end

    it "displays on the page a list of submission for the course programming lab" do
      expect(find("#page-header")).to have_content("Submissions for #{chosen_course_lab.lab_title}")
    end

    context "then viewing the gradebook as a teacher" do
      let(:course_teacher) { create(:course_teacher, course: course) }

      before(:each) do
        logout

        login_as course_teacher.teacher

        click_on "Gradebook"
      end

      it "does something" do
        submission_id = find("#enrollment-#{enrollment.id}-course-lab-#{chosen_course_lab.id}-submission")

        expect(submission_id).to have_content("Not graded")
      end
    end
  end
end
