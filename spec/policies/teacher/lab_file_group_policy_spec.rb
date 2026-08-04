# frozen_string_literal: true

require "rails_helper"

describe Teacher::LabFileGroupPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "grants teacher access" do
      user = instance_double(User, super_teacher?: false, teacher?: true)
      lab_file_group = instance_double(LabFileGroup)

      expect(policy).to permit(user, lab_file_group)
    end

    it "grants denies nonteacher access" do
      user = instance_double(User, super_teacher?: false, teacher?: false)
      lab_file_group = instance_double(LabFileGroup)

      expect(policy).to_not permit(user, lab_file_group)
    end
  end
end
