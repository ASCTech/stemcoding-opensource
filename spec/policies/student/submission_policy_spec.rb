# frozen_string_literal: true

require "rails_helper"

describe Student::SubmissionPolicy do
  subject(:policy) { described_class }

  permissions ".scope" do
    it "lists submissions authored by the urser" do
      enrollment = create(:enrollment)
      submissions = create_list(:submission, 3, author: enrollment)
      other_submissions = create_list(:submission, 3)

      scope = policy::Scope.new(enrollment.student, Submission).resolve

      expect(scope).to match_array submissions
      expect(scope).to_not include(*other_submissions)
    end
  end

  permissions :show? do
    context "when user is a student in the lab" do
      context "when student authored the submission" do
        it "permits" do
          user = instance_double(User)
          submission = instance_double(Submission, authored_by?: true, lab_enrolls_student?: true)

          expect(policy).to permit(user, submission)
        end
      end

      context "when student did not author submisson" do
        it "forbids" do
          user = instance_double(User)
          submission = instance_double(Submission, authored_by?: false, lab_enrolls_student?: true)

          expect(policy).to_not permit(user, submission)
        end
      end
    end
  end

  permissions :create?, :update? do
    context "when user is a student in the lab" do
      context "when the course lab allows submissions" do
        it "grants access" do
          user = instance_double(User)
          submission = instance_double(Submission, lab_enrolls_student?: true, submittable?: true)

          expect(policy).to permit(user, submission)
        end
      end
    end

    context "when user is not a student in the lab" do
      it "denies access" do
        user = instance_double(User)
        submission = instance_double(Submission, lab_enrolls_student?: false, submittable?: true)

        expect(policy).to_not permit(user, submission)
      end
    end

    context "when course lab does not allow submissions" do
      it "denies access" do
        user = instance_double(User)
        submission = instance_double(Submission, lab_enrolls_student?: true, submittable?: false)

        expect(policy).to_not permit(user, submission)
      end
    end
  end
end
