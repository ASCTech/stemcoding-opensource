# frozen_string_literal: true

require "rails_helper"

describe User do
  let(:enrollment) { create(:enrollment) }
  subject(:user) { enrollment.student }

  let(:creator) { create(:user, :admin) }
  let(:teacher) { create(:user, :teacher) }

  let(:enrolled_course) { create(:course, teachers: [teacher], creator: creator, enrollments: [enrollment]) }
  let(:enrolled_course_lab) { create(:course_lab, course: enrolled_course) }

  let(:first_sub) { create(:submission, author: enrollment, course_programming_lab: enrolled_course_lab) }
  let(:mid_sub) { create(:submission, author: enrollment, course_programming_lab: enrolled_course_lab) }
  let(:last_sub) { create(:submission, author: enrollment, course_programming_lab: enrolled_course_lab) }

  it { should have_many(:enrollments).dependent(:destroy) }
  it { should have_many(:enrolled_courses).through(:enrollments) }
  it { should have_many(:taught_courses) }
  it { should have_many(:created_courses) }
  it { should have_many(:enrolled_labs).through(:enrolled_courses) }
  it { should have_many(:taught_labs) }
  it { should have_many(:created_labs) }
  it { should have_many(:students) }
  it { should have_many(:teachers) }

  it { should have_db_column(:first_name).of_type(:string) }
  it { should have_db_column(:last_name).of_type(:string) }
  it { should have_db_column(:prefix).of_type(:string) }
  it { should have_db_column(:suffix).of_type(:string) }
  it { should have_db_column(:admin).of_type(:boolean) }
  it { should have_db_column(:student).of_type(:boolean) }
  it { should have_db_column(:last_active_at).of_type(:datetime) }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:prefix) }
  it { should respond_to(:suffix) }
  it { should respond_to(:admin) }
  it { should respond_to(:student) }
  it { should respond_to(:last_active_at) }
  it { should respond_to(:submissions) }
  it { should respond_to(:complete_name) }
  it { should respond_to(:full_name) }

  it { should respond_to(:email_confirmation) }
  it { should respond_to(:password_confirmation) }

  # Max length
  it { should validate_length_of(:prefix).is_at_most(20) }
  it { should validate_length_of(:suffix).is_at_most(20) }

  # Min length
  it { should validate_length_of(:prefix).is_at_least(2) }
  it { should validate_length_of(:suffix).is_at_least(2) }
  it { should validate_length_of(:password).is_at_least(8) }

  # Presence
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }

  # Uniqueness
  it { should validate_uniqueness_of(:email).case_insensitive }

  # Confirmation
  it { should validate_confirmation_of(:email) }

  it { should_not allow_value(" ").for(:email) }

  describe ".taught_by" do
    it "returns all courses taught by user" do
      taught_courses = create_list(:course, 3, teachers: [teacher], creator: creator)
      other_courses = create_list(:course, 3, creator: creator)

      retrieved_courses = Course.taught_by(teacher)

      expect(retrieved_courses).to match_array taught_courses
      expect(retrieved_courses).not_to include(*other_courses)
    end
  end

  describe "#full_name" do
    it "concatenates first_name w/ last_name" do
      user = build(:user)
      expect(user.full_name).to eq "#{user.first_name} #{user.last_name}"
    end
  end

  describe "#complete_name" do
    it "concatenates the entire name with appropriate titles" do
      user = build(:user, prefix: Faker::Name.prefix, suffix: Faker::Name.suffix)
      expect(user.complete_name).to eq "#{user.prefix} #{user.full_name} #{user.suffix}"
    end
  end

  describe "#complete_name_no_prefix" do
    it "concatenates the entire name when titles are missing" do
      user = build(:user, prefix: nil, suffix: Faker::Name.suffix)
      expect(user.complete_name).to eq "#{user.full_name} #{user.suffix}"
    end
  end

  describe "#complete_name_no_suffix" do
    it "concatenates the entire name when titles are missing" do
      user = build(:user, prefix: Faker::Name.prefix, suffix: nil)
      expect(user.complete_name).to eq "#{user.prefix} #{user.full_name}"
    end
  end

  describe "#complete_name_no_prefix_suffix" do
    it "concatenates the entire name when titles are missing" do
      user = build(:user, prefix: nil, suffix: nil)
      expect(user.complete_name).to eq user.full_name.to_s
    end
  end

  describe "#complete_name_empty_prefix" do
    it "concatenates the entire name when titles are missing" do
      user = build(:user, prefix: "", suffix: Faker::Name.suffix)
      expect(user.complete_name).to eq "#{user.full_name} #{user.suffix}"
    end
  end

  describe "#complete_name_empty_suffix" do
    it "concatenates the entire name when titles are missing" do
      user = build(:user, prefix: Faker::Name.prefix, suffix: "")
      expect(user.complete_name).to eq "#{user.prefix} #{user.full_name}"
    end
  end

  describe "#complete_name_empty_prefix_suffix" do
    it "concatenates the entire name when titles are missing" do
      user = build(:user, prefix: "", suffix: "")
      expect(user.complete_name).to eq user.full_name.to_s
    end
  end

  describe "#get_latest_submission" do
    it "returns the latest submission" do
      enrolled_course_lab
      last_sub

      expect(user.get_latest_submission(enrolled_course_lab)).to eq last_sub
    end
  end

  describe "#has_submission_in_lab?" do
    context "when user has submission in lab" do
      it "is true" do
        enrolled_course_lab
        first_sub

        expect(user.has_submission_in_lab?(enrolled_course_lab)).to be true
      end
    end
  end

  describe "#enroll_in_course" do
    context "when the join key doesn't point to an existing course" do
      it "states that the join key does not point to a course" do
        student = create(:student)

        _, _, message = student.enroll_in_course("aaa")

        expect(message).to eq("The specified join key of: 'aaa' does not point to a Course.")
      end

      it "returns the outcome as false" do
        student = create(:student)

        outcome, _, _ = student.enroll_in_course("aaa")

        expect(outcome).to be false
      end

      it "returns the course as nil" do
        student = create(:student)

        _, course, _ = student.enroll_in_course("aaa")

        expect(course).to be_nil
      end
    end

    context "when the student is already enrolled in the course" do
      it "states that the student is already enrolled in the course" do
        enrollment = create(:enrollment)
        student = enrollment.student
        course = enrollment.course

        _, _, message = student.enroll_in_course(course.join_key)

        expect(message).to eq "You are already enrolled in the course: #{course.title}"
      end

      it "returns the outcome as true" do
        enrollment = create(:enrollment)
        student = enrollment.student
        course = enrollment.course

        outcome, _, _ = student.enroll_in_course(course.join_key)

        expect(outcome).to be true
      end

      it "returns the already enrolled course" do
        enrollment = create(:enrollment)
        student = enrollment.student
        course = enrollment.course

        _, enrolled_course, _ = student.enroll_in_course(course.join_key)

        expect(course.id).to eq enrolled_course.id
      end
    end

    context "when the student is not enrolled in the course yet" do
      it "states the student is already enrolled in the course" do
        student = create(:student)
        course = create(:course)

        _, _, message = student.enroll_in_course(course.join_key)

        expect(message).to eq "You are already enrolled in the course: #{course.title}"
      end

      it "is true" do
        student = create(:student)
        course = create(:course)

        outcome, _, _ = student.enroll_in_course(course.join_key)

        expect(outcome).to be true
      end

      it "returns the newly enrolled course" do
        student = create(:student)
        course = create(:course)

        _, enrolled_course, _ = student.enroll_in_course(course.join_key)

        expect(course.id).to eq enrolled_course.id
      end
    end
  end

  describe ".taught_by" do
    it "retrieves users taught by a particular teacher" do
      course = create(:course)
      enrollments = create_list(:enrollment, 3, course: course)
      students = enrollments.map(&:student)
      course_teacher = create(:course_teacher, course: course)
      teacher = course_teacher.teacher
      lab = create(:course_lab, course: course).programming_lab

      expect(User.taught_by(teacher)).to match_array(students)
      expect(lab.students.taught_by(teacher)).to match_array(students)
    end
  end

  describe "#taught_submissions" do
    it "retrieves all submissions from course labs taught by the user" do
      course_teacher = create(:course_teacher)
      teacher = course_teacher.teacher
      course = course_teacher.course

      course_labs = create_list(:course_lab, 3, course: course)
      course_lab_submissions = create_list(:submission, 3, course_programming_lab: course_labs.sample)
      other_submissions = create_list(:submission, 3)

      actual = teacher.taught_submissions

      expect(actual).to match_array(course_lab_submissions)
      expect(actual).not_to include(*other_submissions)
    end
  end

  describe "#last_weeks_taught_submissions" do
    it "retrieves last week's submissions for courses taught by the user" do
      course_teacher = create(:course_teacher)
      teacher = course_teacher.teacher
      course = course_teacher.course

      course_labs = create_list(:course_lab, 3, course: course)

      course_lab_submissions = course_labs.flat_map { |course_lab|
        create_list(:submission, 3, course_programming_lab: course_lab)
      }

      other_submissions = create_list(:submission, 3)

      actual = teacher.last_weeks_taught_submissions

      expect(actual).to match_array(course_lab_submissions)
      expect(actual).not_to include(*other_submissions)
    end
  end
end
