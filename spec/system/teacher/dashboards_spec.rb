# frozen_string_literal: true

require "rails_helper"
require "array_refinements"

using ArrayRefinements

describe "Teacher dashboard", js: true do
  describe "for each course lab" do
    it "shows the # of ungraded & nonperfect submissions" do
      course = create(:course)
      teacher = create(:course_teacher, course: course).teacher

      course_labs = create_list(:submittable_course_lab, 2, course: course)

      enrollments = create_list(:enrollment, 6, course: course)

      enrollments.take(4).map { |enrollment| create(:graded_submission, author: enrollment, course_programming_lab: course_labs.sample) }

      ungraded_submissions = enrollments.skip(4).map { |enrollment| create(:ungraded_submission, author: enrollment, course_programming_lab: course_labs.sample) }

      login_as teacher

      expect(find("#course-lab-#{course_labs.first.id}-ungraded-submissions")).to have_content(course_labs.first.most_recent_ungraded_submissions.count)
    end
  end
end
