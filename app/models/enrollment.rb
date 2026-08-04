# frozen_string_literal: true

# == Schema Information
#
# Table name: enrollments
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :integer          not null
#  student_id :integer          not null
#
# Indexes
#
#  index_enrollments_on_course_id_and_student_id  (course_id,student_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (student_id => users.id)
#

# Connects students to their enrolled courses
class Enrollment < ApplicationRecord
  belongs_to :course

  delegate :join_key,
    to: :course,
    prefix: :course

  belongs_to :student,
    class_name: "User",
    foreign_key: :student_id,
    inverse_of: :enrollments

  delegate :full_name,
    :email,
    to: :student

  alias_method :user, :student

  has_many :submissions,
    as: :author,
    inverse_of: :author,
    dependent: :restrict_with_exception

  has_many :most_recent_submissions,
    as: :author,
    inverse_of: :author,
    dependent: :restrict_with_exception

  scope :with_join_key, ->(join_key) { joins(:course).merge(Course.with_join_key(join_key)) }
  scope :has_email, ->(email) { joins(:student).merge(User.where(email: email)) }
  scope :enrolled_in, ->(course) { where(course: course) }

  validates :course_id,
    uniqueness: { scope: :student_id }

  def has_submission_for_lab?(lab)
    submissions.for_course(course).for_lab(lab).any?
  end

  def latest_submission_for_lab(lab)
    submissions.for_course(course).for_lab(lab).reorder_by_created_at(:desc).first || NoSubmission.new
  end
end
