class Course::Signup
  include ActiveModel::Model

  attr_reader :course,
    :student,
    :enrollment,
    :email,
    :join_key

  delegate :title,
    to: :course,
    prefix: :course,
    allow_nil: true

  validates :email, presence: true
  validates :join_key, presence: true

  validate :course_exists?
  validate :student_not_enrolled_in_course?

  def join_key=(join_key)
    @join_key = join_key
    @course = Course.find_by(join_key: join_key)
  end

  def email=(email)
    @email = email
    @student = User.find_by(email: email)
  end

  def save
    if valid?
      @enrollment = Enrollment.create(student: student, course: course)
    end
  end

  private

    def enrollment_exists?
      email.present? &&
        join_key.present? &&
        Enrollment.has_email(email)
          .with_join_key(join_key)
          .exists?
    end

    def course_exists?
      return if course.present?

      errors.add(:join_key, "does not refer to an existing course")
    end

    def student_not_enrolled_in_course?
      return unless enrollment_exists?

      errors.add(:join_key, "refers to an existing enrollment")
    end
end
