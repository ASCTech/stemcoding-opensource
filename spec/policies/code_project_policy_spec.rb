# frozen_string_literal: true

require "rails_helper"

describe CodeProjectPolicy do
  subject(:policy) { described_class }

  permissions :show?, :destroy?, :submit?, :submit_pass? do
    it "grants user access to their own projects" do
      user = instance_double(User)
      code_project = instance_double(CodeProject, owned_by?: true)

      expect(policy).to permit(user, code_project)
    end

    it "denies user access to other's projects" do
      user = instance_double(User)
      code_project = instance_double(CodeProject, owned_by?: false)

      expect(policy).to_not permit(user, code_project)
    end
  end

  permissions :index?, :create? do
    it "grants user access" do
      user = instance_double(User)
      project = instance_double(CodeProject)

      expect(policy).to permit(user, project)
    end
  end

  describe "Scope" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    let(:user1_projects) { create_list(:code_project, 5, user: user1) }
    let(:user2_projects) { create_list(:code_project, 5, user: user2) }

    it "returns a users projects" do
      scope1 = policy::Scope.new(user1, CodeProject).resolve
      scope2 = policy::Scope.new(user2, CodeProject).resolve

      expect(scope1).to match_array user1_projects
      expect(scope1).to_not include(*user2_projects)

      expect(scope2).to match_array user2_projects
      expect(scope2).to_not include(*user1_projects)
    end
  end
end
