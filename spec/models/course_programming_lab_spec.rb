# frozen_string_literal: true

require "rails_helper"
require "array_refinements"

using ArrayRefinements

describe CourseProgrammingLab do
  it { should belong_to(:course) }
  it { should belong_to(:programming_lab) }

  describe ".taught_or_course_created_by" do
    it "retrieves course labs taught or created by user" do
      course_teacher = create(:course_teacher)
      created_course = create(:course, creator: course_teacher.teacher)
      taught_course = create(:course, course_teachers: [course_teacher])
      created_course_lab = create(:course_programming_lab, course: created_course)
      taught_course_labs = create_list(:course_programming_lab, 2, course: taught_course)

      other_teacher = create(:course_teacher)
      other_created_course = create(:course, creator: other_teacher.teacher)
      other_created_course_lab = create(:course_programming_lab, course: other_created_course)
      other_taught_course = create(:course, course_teachers: [other_teacher])
      other_taught_course_labs = create_list(:course_programming_lab, 2, course: other_taught_course)

      actual = CourseProgrammingLab.taught_or_course_created_by(course_teacher.teacher)

      expect(actual.count).to eq 3
      expect(actual).to match_array(taught_course_labs | [created_course_lab])
      expect(actual).not_to include(other_created_course_lab)
      expect(actual).not_to include(*other_taught_course_labs)
    end
  end

  describe "#most_recent_ungraded_submissions_count" do
    it "tracks # of ungraded submissions submissions" do
      course_lab = create(:course_lab)
      enrollments = create_list(:enrollment, 6, course: course_lab.course)

      enrollments.take(3).map do |enrollment|
        create(:ungraded_submission, author: enrollment, course_programming_lab: course_lab)
      end

      expect(course_lab.most_recent_ungraded_submissions_count).to eq 3
    end
  end
end
