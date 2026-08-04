# frozen_string_literal: true

require "rails_helper"

describe Admin::UserPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions ".scope" do
    it "grants access to admins" do
      current_user = instance_double(User, admin?: true)
      users = create_list(:user, 3)

      expect(policy::Scope.new(current_user, User).resolve).to match_array users
    end

    it "denies access to nonadmins" do
      create_list(:user, 3)
      current_user = instance_double(User, admin?: false)

      expect(policy::Scope.new(current_user, User).resolve).to be_empty
    end
  end

  permissions :show? do
    it "permits admin access" do
      user = instance_double(User, admin?: true)
      student = nil

      expect(policy).to permit(user, student)
    end

    it "denies nonadmin access" do
      user = instance_double(User, admin?: false)
      student = nil

      expect(policy).to_not permit(user, student)
    end
  end

  permissions :create?, :update?, :destroy? do
    it "permits admin access" do
      user = instance_double(User, admin?: true)
      student = nil

      expect(policy).to permit(user, student)
    end

    it "denies nonadmin access" do
      user = instance_double(User, admin?: false)
      student = nil

      expect(policy).to_not permit(user, student)
    end
  end
end
