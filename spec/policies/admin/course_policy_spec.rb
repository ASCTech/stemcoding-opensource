# frozen_string_literal: true

require "rails_helper"

describe Admin::CoursePolicy do
  let(:user) { User.new }
  subject(:policy) { described_class }

  permissions ".scope" do
    let!(:courses) { create_list(:course, 3) }

    context "when user is an admin" do
      it "lists all courses" do
        admin = instance_double(User, admin?: true)
        scope = policy::Scope.new(admin, Course).resolve

        expect(scope).to match_array courses
      end
    end

    context "when user is not an admin" do
      it "lists no courses" do
        user = instance_double(User, admin?: false)
        scope = policy::Scope.new(user, Course).resolve

        expect(scope).to be_empty
      end
    end
  end

  permissions :index? do
    context "when user is admin" do
      it "permits" do
        admin = instance_double(User, admin?: true)
        course = instance_double(Course)

        expect(policy).to permit(admin, course)
      end
    end

    context "when user is not admin" do
      it "forbids" do
        user = instance_double(User, admin?: false)
        course = instance_double(Course)

        expect(policy).to_not permit(user, course)
      end
    end
  end

  permissions :show? do
    context "when user is admin" do
      it "permits" do
        admin = instance_double(User, admin?: true)
        course = instance_double(Course)

        expect(policy).to permit(admin, course)
      end
    end

    context "when user is not admin" do
      it "forbids" do
        user = instance_double(User, admin?: false)
        course = instance_double(Course)

        expect(policy).to_not permit(user, course)
      end
    end
  end

  permissions :create? do
    context "when user is admin" do
      it "permits" do
        admin = instance_double(User, admin?: true)
        course = instance_double(Course)

        expect(policy).to permit(admin, course)
      end

      it "forbids" do
        user = instance_double(User, admin?: true)
        course = instance_double(Course)

        expect(policy).to permit(user, course)
      end
    end
  end

  permissions :update?, :destroy? do
    context "when user is admin" do
      it "permits" do
        admin = instance_double(User, admin?: true)
        course = instance_double(Course)

        expect(policy).to permit(admin, course)
      end
    end

    context "when user is not admin" do
      it "forbids" do
        nonadmin = instance_double(User, admin?: false)
        course = instance_double(Course)

        expect(policy).not_to permit(nonadmin, course)
      end
    end
  end
end
