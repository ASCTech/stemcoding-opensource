# frozen_string_literal: true

require "rails_helper"

describe Enrollment do
  describe "#has_submission_for_lab?" do
    context "when enrollment has submission for lab" do
      it "is true" do
        enrollment = create(:enrollment)
        course_lab = create(:course_programming_lab, course: enrollment.course)
        create(:submission, course_programming_lab: course_lab, author: enrollment)

        expect(enrollment).to have_submission_for_lab(course_lab.programming_lab)
      end
    end

    context "when enrollment does not submission for lab" do
      it "is false" do
        enrollment = create(:enrollment)
        course_lab = create(:course_programming_lab, course: enrollment.course)

        expect(enrollment).not_to have_submission_for_lab(course_lab.programming_lab)
      end
    end
  end
end
