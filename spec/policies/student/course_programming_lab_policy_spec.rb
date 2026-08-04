require "rails_helper"

describe Student::CourseProgrammingLabPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    context "when student is enrolled in the lab" do
      it "permits" do
        user = instance_double(User, enrolled_in_lab?: true)
        course_lab = instance_double(CourseProgrammingLab, programming_lab: nil)

        expect(policy).to permit(user, course_lab)
      end
    end

    context "when student is not enrolled in the lab" do
      it "forbids" do
        user = instance_double(User, enrolled_in_lab?: false)
        course_lab = instance_double(CourseProgrammingLab, programming_lab: nil)

        expect(policy).not_to permit(user, course_lab)
      end
    end
  end
end
