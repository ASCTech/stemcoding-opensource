# frozen_string_literal: true

require "rails_helper"

describe Student::ProgrammingLabFilePolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "denies nonstudent access" do
      user = instance_double(User)
      lab_file = instance_double(ProgrammingLabFile, lab_enrolls_student?: false)

      expect(policy).not_to permit(user, lab_file)
    end

    context "when lab file is downloadable" do
      it "grants student access" do
        user = instance_double(User)
        lab_file = instance_double(ProgrammingLabFile, lab_enrolls_student?: true, downloadable?: true)

        expect(policy).to permit(user, lab_file)
      end
    end

    context "when lab file is not downloadable" do
      it "denies student access" do
        user = instance_double(User)
        lab_file = instance_double(ProgrammingLabFile, lab_enrolls_student?: true, downloadable?: false)

        expect(policy).to_not permit(user, lab_file)
      end
    end
  end
end
