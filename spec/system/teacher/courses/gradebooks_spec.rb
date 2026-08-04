# frozen_string_literal: true

require "rails_helper"
require "array_refinements"

using ArrayRefinements

describe "Teacher's course gradebook", js: true do
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teachers: [teacher]) }
  let(:course_labs) { create_list(:course_lab, 5, course: course) }
  let(:enrollments) { create_list(:enrollment, 6, course: course) }

  context "when grading a submission for a course programming lab" do
    let!(:ungraded_submissions) do
      enrollments.take(3).map do |enrollment|
        create(:submission,
          course_programming_lab: course_labs.sample,
          author: enrollment)
      end
    end

    let!(:graded_submissions) do
      enrollments.skip(3).map do |enrollment|
        create(:graded_submission,
          course_programming_lab: course_labs.sample,
          author: enrollment)
      end
    end

    let(:ungraded_submission) { ungraded_submissions.sample }

    let(:gradebook) do
      Page::Teacher::Course::Gradebook.new(
        course: course,
        submission: ungraded_submission
      )
    end

    before :each do
      login_as teacher

      gradebook.grade_submission
    end

    it "shows submission's updated grade" do
      expect(gradebook).to have_updated_grade(for_submission: ungraded_submission)
    end

    it "notifies user that they have updated the submission's grade" do
      expect(gradebook).to have_notification
    end
  end

  context "when updating an already graded submission for a course lab" do
    let!(:submissions) do
      enrollments.map do |enrollment|
        create(
          :graded_submission,
          course_programming_lab: course_labs.sample,
          author: enrollment
        )
      end
    end

    let(:submission_to_be_graded) { submissions.sample }

    let(:gradebook) do
      Page::Teacher::Course::Gradebook.new(
        course: course,
        submission: submission_to_be_graded
      )
    end

    before :each do
      login_as teacher

      gradebook.grade_submission
    end

    it "shows submission's updated grade" do
      expect(gradebook).to have_updated_grade(for_submission: submission_to_be_graded)
    end

    it "notifies user that they have updated the submission's grade" do
      expect(gradebook).to have_notification
    end
  end
end
