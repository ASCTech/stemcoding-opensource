# frozen_string_literal: true

require "rails_helper"

describe Student::GradebookPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "denies nonstudent access" do
      user = instance_double(User, student?: false)
      gradebook = nil

      expect(policy).to_not permit(user, gradebook)
    end

    it "gives student access" do
      user = instance_double(User, student?: true)
      gradebook = nil

      expect(policy).to permit(user, gradebook)
    end
  end
end
