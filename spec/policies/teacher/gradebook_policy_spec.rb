# frozen_string_literal: true

require "rails_helper"

describe Teacher::GradebookPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    context "when user is an admin" do
      it "permits" do
        user = instance_double(User, teacher?: false, super_teacher?: false, admin?: true)
        gradebook = nil

        expect(policy).to permit(user, gradebook)
      end
    end

    context "when user is a teacher" do
      it "permits" do
        user = instance_double(User, teacher?: true, super_teacher?: false, admin?: false)
        gradebook = nil

        expect(policy).to permit(user, gradebook)
      end
    end

    context "when user is a superteacher" do
      it "permits" do
        user = instance_double(User, teacher?: false, super_teacher?: true, admin?: false)
        gradebook = nil

        expect(policy).to permit(user, gradebook)
      end
    end

    context "when user is not a teacher or an admin" do
      it "forbids" do
        user = instance_double(User, teacher?: false, super_teacher?: false, admin?: false)
        gradebook = nil

        expect(policy).not_to permit(user, gradebook)
      end
    end
  end
end
