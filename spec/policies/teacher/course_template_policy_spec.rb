# frozen_string_literal: true

require "rails_helper"

describe Teacher::CourseTemplatePolicy do
  subject(:policy) { described_class }

  permissions :index? do
    it "denies nonteacher access" do
      user = instance_double(User, teacher?: false, super_teacher?: false)
      course = nil

      expect(policy).not_to permit(user, course)
    end

    it "grants teacher access" do
      user = instance_double(User, teacher?: true, super_teacher?: false)
      course = nil

      expect(policy).to permit(user, course)
    end
  end

  permissions :show? do
    context "when the course is a template" do
      it "grants teacher access" do
        user = instance_double(User, teacher?: true, super_teacher?: false)
        course = instance_double(Course, template?: true)

        expect(policy).to permit(user, course)
      end
    end

    context "when course is not a template" do
      it "denies teacher access" do
        user = instance_double(User, teacher?: true, super_teacher?: false)
        course = instance_double(Course, template?: false)

        expect(policy).to_not permit(user, course)
      end
    end

    it "denies nonteacher access" do
      user = instance_double(User, teacher?: false, super_teacher?: false)
      course = instance_double(Course, template?: true)

      expect(policy).not_to permit(user, course)
    end
  end

  permissions :create? do
    it "grants teacher access" do
      user = instance_double(User, teacher?: true, super_teacher?: false)
      course = instance_double(Course)

      expect(policy).to permit(user, course)
    end

    it "denies nonteacher access" do
      user = instance_double(User, teacher?: false, super_teacher?: false)
      course = instance_double(Course)

      expect(policy).to_not permit(user, course)
    end
  end

  describe Teacher::CourseTemplatePolicy::Scope do
    subject(:scope) { described_class }

    it "grants access to teacher" do
      teacher = instance_double(User, teacher?: true, super_teacher?: false)
      course_templates = create_list(:course_template, 3)
      courses = create_list(:course, 3, template: false)

      scoped_courses = scope.new(teacher, Course).resolve

      expect(scoped_courses).to match_array course_templates
      expect(scoped_courses).to_not include(*courses)
    end

    it "denies access to nonteachers" do
      teacher = instance_double(User, teacher?: false, super_teacher?: false)
      create_list(:course_template, 3)

      scoped_courses = scope.new(teacher, Course).resolve

      expect(scoped_courses).to be_empty
    end
  end
end
