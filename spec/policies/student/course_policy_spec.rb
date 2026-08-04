# frozen_string_literal: true

require "rails_helper"

describe Student::CoursePolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions ".scope" do
    let(:student) { create(:student) }
    let(:taught_courses) { create_list(:course_teacher, 3).map(&:course) }
    let(:enrolled_courses) { create_list(:enrollment, 3, student: student).map(&:course) }
    let!(:courses) { taught_courses | enrolled_courses }

    it "lists courses in which the user is enrolled as a student" do
      scope = policy::Scope.new(student, Course).resolve

      expect(scope).to match_array(enrolled_courses)
      expect(scope).to_not include(*taught_courses)
    end
  end

  permissions :show? do
    context "when user is enrolled as student in course" do
      it "permits" do
        student = instance_double(User, enrolled_in_course?: true)
        course = instance_double(Course)

        expect(policy).to permit(student, course)
      end
    end

    context "when user is not enrolled as student in course" do
      it "forbids" do
        user = instance_double(User, enrolled_in_course?: false, admin?: true)
        course = instance_double(Course)

        expect(policy).to_not permit(user, course)
      end
    end
  end

  permissions :create?, :update?, :destroy? do
    it "forbids" do
      user = instance_double(User)
      course = instance_double(Course)
      expect(policy).not_to permit(user, course)
    end
  end
end
