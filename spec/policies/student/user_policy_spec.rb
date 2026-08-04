# frozen_string_literal: true

require "rails_helper"

describe Student::UserPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "denies everybody access" do
      user = instance_double(User)
      student = nil

      expect(policy).to_not permit(user, student)
    end
  end
end
