# frozen_string_literal: true

require "rails_helper"

describe Student::ProgrammingLabPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "denies nonstudent access" do
      user = instance_double(User, enrolled_in_lab?: false, admin?: false)
      lab = instance_double(ProgrammingLab)
      expect(policy).not_to permit(user, lab)
    end

    it "gives student access" do
      user = instance_double(User, enrolled_in_lab?: true, admin?: false)
      lab = instance_double(ProgrammingLab)
      expect(policy).to permit(user, lab)
    end
  end

  describe Student::ProgrammingLabPolicy::Scope do
    subject(:scope) { described_class }

    let(:student) { create(:student) }
    let!(:enrolled_labs) do
      create_list(:enrollment, 3, student: student).map(&:course).map do |course|
        create(:course_programming_lab, course: course).programming_lab
      end
    end

    let!(:other_labs) { create_list(:programming_lab, 3) }

    it "lists programming labs where the user is enrolled a student" do
      resolved = scope.new(student, ProgrammingLab).resolve

      expect(resolved).to match_array enrolled_labs
      expect(resolved).to_not include(*other_labs)
    end
  end
end
