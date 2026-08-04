# frozen_string_literal: true

require "rails_helper"

describe Admin::ProgrammingLabPolicy do
  let(:user) { User.new }
  subject(:policy) { described_class }

  permissions :show? do
    it "gives admin access" do
      admin = instance_double(User, admin?: true)
      lab = instance_double(ProgrammingLab)

      expect(policy).to permit(admin, lab)
    end

    it "denies nonadmin access" do
      admin = instance_double(User, admin?: false)
      lab = instance_double(ProgrammingLab)

      expect(policy).to_not permit(admin, lab)
    end
  end

  permissions :create?, :update?, :destroy? do
    it "gives admin access" do
      admin = instance_double(User, admin?: true)
      lab = instance_double(ProgrammingLab)

      expect(policy).to permit(admin, lab)
    end

    it "denies admin access" do
      user = instance_double(User, admin?: false)
      lab = instance_double(ProgrammingLab)

      expect(policy).not_to permit(user, lab)
    end
  end

  describe Admin::ProgrammingLabPolicy::Scope do
    subject(:scope) { described_class }

    context "when the user is an admin" do
      it "lists all programming labs" do
        admin = create(:admin)
        labs = create_list(:programming_lab, 3)

        resolved = scope.new(admin, ProgrammingLab).resolve

        expect(resolved).to match_array labs
      end
    end

    context "when hte user is not an admin" do
      it "lists no programming labs" do
        teacher = create(:teacher)
        create_list(:programming_lab, 3)

        resolved = scope.new(teacher, ProgrammingLab).resolve

        expect(resolved).to be_empty
      end
    end
  end
end
