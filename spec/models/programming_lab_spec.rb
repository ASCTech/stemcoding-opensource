# frozen_string_literal: true

require "rails_helper"

describe ProgrammingLab do
  subject { build(:programming_lab) }

  it { should have_many(:submissions) }
  it { should have_many(:courses).through(:course_programming_labs) }
  it { should have_many(:file_groups).class_name("LabFileGroup") }

  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:content).of_type(:text) }
  it { should have_db_column(:template).of_type(:boolean) }
  it { should have_db_column(:creator_id).of_type(:integer) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }
  it { should validate_uniqueness_of(:title).case_insensitive }

  describe ".taught_by" do
    it "returns programming labs taught by a user" do
      teacher = create(:user)

      taught_labs =
        create_list(:course_teacher, 3, teacher: teacher)
          .map(&:course)
          .map { |course| create(:course_programming_lab, course: course).programming_lab }

      other_labs = create_list(:programming_lab, 3)

      retrieved_labs = ProgrammingLab.taught_by(teacher)

      expect(retrieved_labs).to match_array taught_labs
      expect(retrieved_labs).to_not include(*other_labs)
    end
  end

  describe ".enrolls" do
    it "returns programming labs in which the student is enrolled" do
      student = create(:user)

      enrolled_labs = create_list(:enrollment, 3, student: student).map(&:course).map { |course|
        create(:course_programming_lab, course: course).programming_lab
      }

      other_labs = create_list(:programming_lab, 3)

      retrieved_labs = ProgrammingLab.enrolls(student)

      expect(retrieved_labs).to match_array enrolled_labs
      expect(retrieved_labs).to_not include(*other_labs)
    end
  end

  describe "#compose" do
    it "returns a composition of the programming lab\'s display name" do
      pl = build(:programming_lab)
      expect(pl.compose).to eq pl.title.to_s
    end
  end

  describe "#taught_by?" do
    context "when user is a teacher of the programming lab" do
      it "is true" do
        course_programming_lab = create(:course_programming_lab)
        course_teacher = create(:course_teacher, course: course_programming_lab.course)
        teacher = course_teacher.teacher
        lab = course_programming_lab.programming_lab

        expect(lab.taught_by?(teacher)).to be true
      end
    end

    context "when user is not a teacher of the programming lab" do
      it "is false" do
        course_programming_lab = create(:course_programming_lab)
        other_user = create(:user)
        lab = course_programming_lab.programming_lab

        expect(lab.taught_by?(other_user)).to be false
      end
    end
  end
end
