require "rails_helper"

describe Course::Signup do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:join_key) }

  context "when the course does not exist" do
    it "is invalid" do
      course_attributes = attributes_for(:course)

      signup = Course::Signup.new(join_key: course_attributes.fetch(:join_key))

      expect(signup).not_to be_valid
      expect(signup.errors.full_messages).to include("Join key does not refer to an existing course")
    end
  end

  context "when student is already enrolled in course" do
    it "is invalid" do
      enrollment = create(:enrollment)
      course = enrollment.course
      student = enrollment.student

      signup = Course::Signup.new(join_key: course.join_key, email: student.email)

      expect(signup).not_to be_valid
      expect(signup.errors.full_messages).to include("Join key refers to an existing enrollment")
    end
  end

  context "when student is not enrolled in existing course" do
    it "is invalid" do
      course = create(:course)
      student = create(:student)

      signup = Course::Signup.new(join_key: course.join_key, email: student.email)

      expect(signup).to be_valid
    end
  end
end
