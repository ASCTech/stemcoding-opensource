# frozen_string_literal: true

require "rails_helper"

describe Teacher::SubmissionFilePolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "denies nonteacher access" do
      user = instance_double(User, super_teacher?: false)
      submission_file = instance_double(SubmissionFile, lab_taught_by?: false)

      expect(policy).not_to permit(user, submission_file)
    end

    it "grants teacher access" do
      user = instance_double(User, super_teacher?: false)
      submission_file = instance_double(SubmissionFile, lab_taught_by?: true)

      expect(policy).to permit(user, submission_file)
    end
  end
end
