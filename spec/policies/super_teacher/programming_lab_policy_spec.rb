require "rails_helper"

describe SuperTeacher::ProgrammingLabPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show?, :create? do
    context "when the user is a super teacher" do
      it "permits" do
        super_teacher = instance_double(User, super_teacher?: true)
        lab = instance_double(ProgrammingLab)

        expect(policy).to permit(super_teacher, lab)
      end
    end

    context "when the user is not a super teacher" do
      it "forbids" do
        super_teacher = instance_double(User, super_teacher?: false)
        lab = instance_double(ProgrammingLab)

        expect(policy).not_to permit(super_teacher, lab)
      end
    end
  end

  permissions :update? do
    context "when the user is a super teacher" do
      context "when the user authored the lab" do
        it "permits" do
          super_teacher = instance_double(User, super_teacher?: true)
          lab = instance_double(ProgrammingLab, authored_by?: true, has_submissions?: false)

          expect(policy).to permit(super_teacher, lab)
        end
      end

      context "when the user did not author the lab" do
        it "forbids" do
          super_teacher = instance_double(User, super_teacher?: true)
          lab = instance_double(ProgrammingLab, authored_by?: false)

          expect(policy).not_to permit(super_teacher, lab)
        end
      end
    end

    context "when the user is not a super teacher" do
      it "forbids" do
        super_teacher = instance_double(User, super_teacher?: false)
        lab = instance_double(ProgrammingLab)

        expect(policy).not_to permit(super_teacher, lab)
      end
    end
  end
end
