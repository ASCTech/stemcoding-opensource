# frozen_string_literal: true

require "rails_helper"

describe Student::LabFileGroupPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "gives student access" do
      user = instance_double(User, admin?: false)
      lab_file_group = instance_double(LabFileGroup, lab_enrolls_student?: true)

      expect(policy).to permit(user, lab_file_group)
    end

    it "denies nonstudent access" do
      user = instance_double(User, admin?: false)
      lab_file_group = instance_double(LabFileGroup, lab_enrolls_student?: false)

      expect(policy).to_not permit(user, lab_file_group)
    end
  end
end
