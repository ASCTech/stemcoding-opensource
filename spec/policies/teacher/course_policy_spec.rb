# frozen_string_literal: true

require "rails_helper"

describe Teacher::CoursePolicy do
  subject(:policy) { described_class }

  permissions ".scope" do
    let(:teacher) { create(:teacher) }

    let(:taught_courses) { create_list(:course_teacher, 3, teacher: teacher).map(&:course) }
    let(:enrolled_courses) { create_list(:course, 3) }
    let!(:courses) { taught_courses | enrolled_courses }

    it "lists courses the user teaches" do
      scope = policy::Scope.new(teacher, Course).resolve

      expect(scope).to match_array taught_courses
      expect(scope).to_not include(*enrolled_courses)
    end
  end

  permissions :show? do
    context "when user is an admin" do
      it "permits" do
        admin = instance_double(User, admin?: true)
        course = instance_double(Course, taught_or_created_by?: false, has_submissions?: true, template?: false)

        expect(policy).to permit(admin, course)
      end
    end
  end

  permissions :update? do
    context "when the user teaches the course" do
      it "permits" do
        teacher = instance_double(User)
        course = instance_double(Course, taught_or_created_by?: true)

        expect(policy).to permit(teacher, course)
      end
    end

    context "when user does not teach course" do
      it "forbids" do
        admin = instance_double(User, admin?: false)
        course = instance_double(Course, taught_or_created_by?: false, template?: false)

        expect(policy).not_to permit(admin, course)
      end
    end
  end

  permissions :destroy? do
    context "when the user teaches the course" do
      context "when no course submissions exist" do
        it "permits" do
          teacher = instance_double(User)
          course = instance_double(Course, taught_or_created_by?: true, has_submissions?: false)

          expect(policy).to permit(teacher, course)
        end
      end

      context "when course submissions exist" do
        it "forbids" do
          teacher = instance_double(User)
          course = instance_double(Course, taught_or_created_by?: true, has_submissions?: true)

          expect(policy).not_to permit(teacher, course)
        end
      end
    end

    context "when user does not teach course" do
      it "forbids" do
        admin = instance_double(User, admin?: false)
        course = instance_double(Course, taught_or_created_by?: false, has_submissions?: false, template?: false)

        expect(policy).not_to permit(admin, course)
      end
    end
  end

  permissions :create? do
    context "when the user is a teacher" do
      it "permits" do
        teacher = instance_double(User, teacher?: true)
        course = instance_double(Course)

        expect(policy).to permit(teacher, course)
      end
    end

    context "when user is not a teacher" do
      it "forbids" do
        teacher = instance_double(User, teacher?: false, super_teacher?: false)
        course = instance_double(Course)

        expect(policy).to_not permit(teacher, course)
      end
    end
  end
end
