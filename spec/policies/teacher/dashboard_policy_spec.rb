# frozen_string_literal: true

require "rails_helper"

describe Teacher::DashboardPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "grants teacher access" do
      teacher = instance_double(User, teacher?: true, super_teacher?: false)

      expect(policy).to permit(teacher, :dashboard)
    end

    it "denies nonteacher access" do
      teacher = instance_double(User, teacher?: false, super_teacher?: false)

      expect(policy).to_not permit(teacher, :dashboard)
    end
  end
end
