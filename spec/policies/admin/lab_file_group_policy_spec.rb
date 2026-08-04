# frozen_string_literal: true

require "rails_helper"

describe Admin::LabFileGroupPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "grants admin access" do
      user = instance_double(User, admin?: true)
      lab_file_group = nil

      expect(policy).to permit(user, lab_file_group)
    end

    it "denies nonadmin access" do
      user = instance_double(User, admin?: false)
      lab_file_group = nil

      expect(policy).to_not permit(user, lab_file_group)
    end
  end
end
