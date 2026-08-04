# frozen_string_literal: true

require "rails_helper"

describe Student::DashboardPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "grants student access" do
      student = instance_double(User, student?: true)

      expect(policy).to permit(student, :dashboard)
    end

    it "denies nonstudent access" do
      nonstudent = instance_double(User, student?: false)

      expect(policy).to_not permit(nonstudent, :dashboard)
    end
  end
end
