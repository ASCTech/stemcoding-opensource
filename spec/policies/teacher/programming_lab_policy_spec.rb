# frozen_string_literal: true

require "rails_helper"

describe Teacher::ProgrammingLabPolicy do
  let(:user) { User.new }

  subject(:policy) { described_class }

  permissions :show? do
    it "denies nonteachers access" do
      user = instance_double(User, super_teacher?: false, teacher?: false, instructor_for_lab?: false)
      lab = instance_double(ProgrammingLab)

      expect(policy).not_to permit(user, lab)
    end

    it "gives teachers access" do
      user = instance_double(User, super_teacher?: false, teacher?: true, instructor_for_lab?: false)
      lab = instance_double(ProgrammingLab)

      expect(policy).to permit(user, lab)
    end
  end

  describe Teacher::ProgrammingLabPolicy::Scope do
    subject(:scope) { described_class }

    let(:teacher) { create(:super_teacher) }
    let!(:taught_labs) do
      create_list(:course_teacher, 3, teacher: teacher).map(&:course).map do |course|
        create(:course_programming_lab, course: course).programming_lab
      end
    end

    let!(:authored_labs) { create_list(:programming_lab, 3, creator: teacher) }
    let!(:other_labs) { create_list(:programming_lab, 3) }

    it "lists programming labs taught or authored by the teacher" do
      resolved = scope.new(teacher, ProgrammingLab).resolve

      all_labs = taught_labs | authored_labs | other_labs

      expect(resolved).to match_array all_labs
    end
  end
end
