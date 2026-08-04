# frozen_string_literal: true

require "rails_helper"

describe Admin::ProgrammingLabFilePolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "grants admin access" do
      user = instance_double(User, admin?: true)
      lab_file = instance_double(ProgrammingLabFile)

      expect(policy).to permit(user, lab_file)
    end

    it "denies nonadmin access" do
      user = instance_double(User, admin?: false)
      lab_file = instance_double(ProgrammingLabFile)

      expect(policy).to_not permit(user, lab_file)
    end
  end
end
