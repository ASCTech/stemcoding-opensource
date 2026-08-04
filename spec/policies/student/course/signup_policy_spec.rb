require "rails_helper"

describe Student::Course::SignupPolicy do
  subject(:policy) { described_class }

  permissions :create? do
    context "when the user is a student" do
      it "permits" do
        student = instance_double(User, student?: true)
        signup = nil

        expect(policy).to permit(student, signup)
      end
    end

    context "when the user is not a student" do
      it "forbids" do
        student = instance_double(User, student?: false)
        signup = nil

        expect(policy).not_to permit(student, signup)
      end
    end
  end
end
