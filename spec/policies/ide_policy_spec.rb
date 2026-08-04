# frozen_string_literal: true

require "rails_helper"

describe IdePolicy do
  subject(:policy) { described_class }

  permissions :send_code?, :split_pass? do
    it "grants anybody access" do
      admin = instance_double(User)
      ide = nil

      expect(policy).to permit(admin, ide)
    end
  end
end
