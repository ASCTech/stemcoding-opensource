# frozen_string_literal: true

require "rails_helper"

describe Admin::DashboardPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "grants admin access" do
      admin = instance_double(User, admin?: true)

      expect(policy).to permit(admin, :dashboard)
    end

    it "denies nonadmin access" do
      nonadmin = instance_double(User, admin?: false)

      expect(policy).to_not permit(nonadmin, :dashboard)
    end
  end
end
