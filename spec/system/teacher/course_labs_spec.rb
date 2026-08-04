require "rails_helper"

describe "Teacher course labs", js: true do
  let(:course_teacher) { create(:course_teacher) }
  let(:course_lab) { create(:closed_course_lab, course: course_teacher.course) }
  let(:enrollments) { create_list(:enrollment, 3, course: course_teacher.course) }

  let!(:submissions) do
    enrollments.map do |enrollment|
      create(:submission, course_programming_lab: course_lab, author: enrollment).tap do |sub|
        create(:submission_file, submission: sub)
      end
    end
  end

  before :each do
    login_as course_teacher.teacher

    click_on course_lab.course_title
    click_on course_lab.lab_title
  end

  describe "showing" do
    describe "allowing submissions" do
      it "changes the status of the submissions from prohibited to allowed" do
        checkbox = find("label[for='course-lab-#{course_lab.id}-submittable-checkbox']")

        expect(checkbox).to have_content("Submissions prohibited")

        checkbox.click

        expect(checkbox).to have_content("Submissions allowed")
      end
    end

    describe "prohibiting submissions" do
      let(:course_lab) { create(:course_programming_lab, submittable: false, course: course_teacher.course) }
      it "changes the status of the submissions from allowed to prohibited" do
        checkbox = find("label[for='course-lab-#{course_lab.id}-submittable-checkbox']")

        expect(checkbox).to have_content("Submissions prohibited")

        checkbox.click

        expect(checkbox).to have_content("Submissions allowed")
      end
    end
  end

  describe "viewing submissions" do
    describe "grading a submission" do
      before :each do
        click_on submissions.first.compose

        fill_in "Instructor comment", with: "Instructor comment"
        fill_in "Grade", with: 9.0
        click_on "Submit Grade and Comment"
      end

      it "notifies the teacher the submission has been successfully graded" do
        expect(find(".alert-notice")).to have_content("#{submissions.first.author_full_name}'s grade for #{submissions.first.lab_title} updated.")
      end
    end
  end
end
