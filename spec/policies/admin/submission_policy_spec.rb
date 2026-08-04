# frozen_string_literal: true

require "rails_helper"

describe Admin::SubmissionPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    context "when user is admin" do
      it "permits" do
        user = instance_double(User, admin?: true)
        submission = nil

        expect(policy).to permit(user, submission)
      end
    end

    context "when user is not admin" do
      it "forbids" do
        user = instance_double(User, admin?: false)
        submission = nil

        expect(policy).not_to permit(user, submission)
      end
    end
  end
end
