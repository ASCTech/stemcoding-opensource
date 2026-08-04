# frozen_string_literal: true

require "rails_helper"

describe Course do
  subject { build(:course) }

  it { should belong_to(:creator).class_name("User") }

  it { should have_many(:course_programming_labs) }
  it { should have_many(:programming_labs).through(:course_programming_labs) }

  it { should have_many(:enrollments).inverse_of(:course).dependent(:destroy) }
  it { should have_many(:students).through(:enrollments).class_name("User") }
  it { should have_many(:teachers).class_name("User") }

  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:join_key).of_type(:string) }

  it { should have_db_column(:description).of_type(:text) }
  it { should have_db_column(:template).of_type(:boolean).with_options(default: false) }

  it { should have_db_column(:creator_id).of_type(:integer) }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:template) }
  it { should respond_to(:join_key) }
  it { should respond_to(:creator) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:creator) }

  it { should validate_uniqueness_of(:join_key) }

  describe ".taught_by" do
    it "returns courses taught by a user" do
      teacher = create(:user)
      taught_courses = create_list(:course_teacher, 3, teacher: teacher).map(&:course)
      other_courses = create_list(:course, 3)

      retrieved_courses = Course.taught_by(teacher)

      expect(retrieved_courses).to match_array(taught_courses)
      expect(retrieved_courses).to_not include(*other_courses)
    end
  end

  describe ".taught_or_created_by" do
    it "fetches courses taught or created by the user" do
      course_teacher = create(:course_teacher)
      taught_course = course_teacher.course
      created_course = create(:course, creator: course_teacher.teacher)

      courses = Course.taught_or_created_by(course_teacher.teacher)

      expect(courses).to match_array([taught_course, created_course])
    end

    context "when the user created the course & and more than one person teaches the course" do
      it "only lists the course once" do
        course = create(:course)
        course_teacher = create(:course_teacher, teacher: course.creator, course: course)

        # other course teacher
        create(:course_teacher, course: course)

        courses = Course.taught_or_created_by(course_teacher.teacher)

        expect(courses).to match_array([course])
      end
    end
  end

  describe ".enrolls" do
    it "returns courses where in which the student is enrolled" do
      student = create(:user)
      enrolled_courses = create_list(:enrollment, 3, student: student).map(&:course)
      other_courses = create_list(:course, 3)

      retrieved_courses = Course.enrolls(student)

      expect(retrieved_courses).to match_array(enrolled_courses)
      expect(retrieved_courses).to_not include(*other_courses)
    end
  end

  describe "#compose_no_template" do
    it "returns a composition of the course\'s display name" do
      c = build(:course, template: false)
      expect(c.compose).to eq c.title.to_s
    end
  end

  describe "#compose_with_template" do
    it "returns a composition of the course\'s display name" do
      c = build(:course, template: true)
      expect(c.compose).to eq "[TEMPLATE] #{c.title}"
    end
  end

  describe "#gen_key" do
    it "returns a 20 character randomly generated join_key" do
      c = build(:course, template: false)
      key = c.gen_key
      # Check length of string
      expect(key.length).to eq 20

      # Check to make sure it is only composed of valid characters.
      valid_chars = [("a".."z"), ("A".."Z"), ("0".."9")].flat_map(&:to_a)
      expect(key.split("") - valid_chars).to be_empty
    end
  end

  describe "#gen_key!" do
    it "sets the courses join_key to a new randomly generated string of 20 characters" do
      c = build(:course, template: false)
      old_key = c.gen_key!
      # Check to see if the old key set correctly.
      expect(c.join_key).to be_truthy
      expect(c.join_key.length).to eq 20

      new_key = c.gen_key!

      expect(c.join_key).to eq new_key
      expect(new_key).not_to eq old_key
    end
  end

  describe "#clone" do
    let(:creator) { build(:user) }
    let(:teacher) { build(:teacher) }
    let(:lab_1) { build(:programming_lab) }
    let(:lab_2) { build(:programming_lab) }
    let(:template) { build(:course_template, creator: creator) }

    it "clones a course from a template" do
      template.programming_labs.push lab_1
      template.programming_labs.push lab_2

      title = Faker::University.name

      course = template.clone(title: title, teacher: teacher)

      # Check the cloned course to verify that it is properly set up
      # The following checks are for elements not shared with the template
      # course.
      expect(course.title).to eq title
      expect(course.teachers).to include teacher
      expect(course.template).to eq false
      expect(course.join_key).not_to eq template.join_key
      expect(course.join_key.length).to eq 20

      # The following checks are for elements that should be copied over from
      # the template course.
      expect(course.programming_labs).to include lab_1
      expect(course.programming_labs).to include lab_2
      expect(course.description).to eq template.description
      expect(course.creator).to eq creator
      # This test isn't actually necessary, but might as well add it in in the
      # event it somehow manages to fail while the previous one functioned.
      expect(course.creator).to eq template.creator
    end
  end
end
