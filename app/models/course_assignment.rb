class CourseAssignment
  include ActiveModel::Model

  attr_writer :courses

  attr_accessor :programming_lab

  validates :programming_lab, presence: true

  def courses
    Array(@courses)
  end

  def save
    return unless valid?

    programming_lab.courses << courses
  end

  private

    def courses_exist?
      return if courses.any?

      errors.add(:courses, "At least one course must be assigned to the lab.")
    end
end
