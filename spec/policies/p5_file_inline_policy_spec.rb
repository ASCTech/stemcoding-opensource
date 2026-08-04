# frozen_string_literal: true

require "rails_helper"

describe P5FileInlinePolicy do
  subject(:policy) { described_class }

  permissions :show? do
    context "when user is an admin" do
      it "permits" do
        user = instance_double(User, admin?: true)
        lab_file = instance_double(ProgrammingLabFile, lab_enrolls_student?: false, lab_taught_by?: false)

        expect(policy).to permit(user, lab_file)
      end
    end

    context "when user is enrolled in the programming lab" do
      it "permits" do
        user = instance_double(User, admin?: false)
        lab_file = instance_double(ProgrammingLabFile, lab_enrolls_student?: true, lab_taught_by?: false)

        expect(policy).to permit(user, lab_file)
      end
    end

    context "when user is the instructor for the programming lab" do
      it "permits" do
        user = instance_double(User, admin?: false)
        lab_file = instance_double(ProgrammingLabFile, lab_enrolls_student?: false, lab_taught_by?: true)

        expect(policy).to permit(user, lab_file)
      end
    end

    context "when the user is neither an admin, enrolled in the lab, nor an instructor for the lab" do
      it "forbids" do
        user = instance_double(User, admin?: false, super_teacher?: false)
        lab_file = instance_double(ProgrammingLabFile, lab_enrolls_student?: false, lab_taught_by?: false)

        expect(policy).to_not permit(user, lab_file)
      end
    end
  end
end
