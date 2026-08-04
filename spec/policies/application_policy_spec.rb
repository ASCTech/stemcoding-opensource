# frozen_string_literal: true

require "rails_helper"

describe ApplicationPolicy do
  subject(:policy) { described_class }
  let(:admin) { instance_double(User, admin?: true) }

  permissions :index?, :show?, :create?, :update?, :destroy? do
    it "denies permission to everybody" do
      user = instance_double(User)
      expect(policy).to_not permit(user, nil)
    end
  end
end
