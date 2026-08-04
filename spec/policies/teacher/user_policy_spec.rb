# frozen_string_literal: true

require "rails_helper"

describe Teacher::UserPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "grants teacher access" do
      user = instance_double(User)
      student = instance_double(User, taught_by?: true)

      expect(policy).to permit(user, student)
    end

    it "denies nonteacher access" do
      user = instance_double(User)
      student = instance_double(User, taught_by?: false)

      expect(policy).to_not permit(user, student)
    end
  end
end
