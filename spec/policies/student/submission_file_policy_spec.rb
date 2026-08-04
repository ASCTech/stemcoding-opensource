# frozen_string_literal: true

require "rails_helper"

describe Student::SubmissionFilePolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "grants student access" do
      user = instance_double(User)
      submission_file = instance_double(SubmissionFile, submission_authored_by?: true)

      expect(policy).to permit(user, submission_file)
    end

    it "denies nonstudent access" do
      user = instance_double(User)
      submission_file = instance_double(SubmissionFile, submission_authored_by?: false)

      expect(policy).to_not permit(user, submission_file)
    end
  end
end
