# frozen_string_literal: true

require "rails_helper"

describe Admin::SubmissionFilePolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    context "when user is not admin" do
      it "forbids" do
        user = instance_double(User, admin?: false)
        submission_file = nil

        expect(policy).not_to permit(user, submission_file)
      end
    end

    context "when user is admin" do
      it "permits" do
        user = instance_double(User, admin?: true)
        submission_file = nil

        expect(policy).to permit(user, submission_file)
      end
    end
  end
end
