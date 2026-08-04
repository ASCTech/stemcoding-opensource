# frozen_string_literal: true

require "rails_helper"

describe Teacher::SubmissionPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    context "when user instructs submission author" do
      context "when user teaches programming lab" do
        it "permits" do
          user = instance_double(User)
          submission = instance_double(Submission, author_taught_by?: true, lab_taught_by?: true)

          expect(policy).to permit(user, submission)
        end
      end

      context "when user doesn't teach programming lab" do
        it "forbids" do
          user = instance_double(User)
          submission = instance_double(Submission, author_taught_by?: true, lab_taught_by?: false)

          expect(policy).to_not permit(user, submission)
        end
      end
    end

    context "when user doesn't teach submission author" do
      it "forbids" do
        user = instance_double(User)
        submission = instance_double(Submission, author_taught_by?: false, lab_taught_by?: true)

        expect(policy).to_not permit(user, submission)
      end
    end
  end

  permissions :update? do
    context "when user teaches submission author" do
      context "when lab is taught by user" do
        it "permits" do
          user = instance_double(User)
          submission = instance_double(Submission, author_taught_by?: true, lab_taught_by?: true)

          expect(policy).to permit(user, submission)
        end
      end

      context "when lab is not taught by user" do
        it "forbids" do
          user = instance_double(User)
          submission = instance_double(Submission, author_taught_by?: true, lab_taught_by?: false)

          expect(policy).to_not permit(user, submission)
        end
      end
    end

    context "when user does not teach submission author" do
      it "forbids" do
        user = instance_double(User)
        submission = instance_double(Submission, author_taught_by?: false, lab_taught_by?: true)

        expect(policy).to_not permit(user, submission)
      end
    end
  end
end
