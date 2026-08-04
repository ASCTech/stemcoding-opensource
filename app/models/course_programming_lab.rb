# frozen_string_literal: true

# == Schema Information
#
# Table name: course_programming_labs
#
#  id                 :integer          not null, primary key
#  position           :integer          not null
#  submittable        :boolean          default(TRUE), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  course_id          :integer          not null
#  programming_lab_id :integer          not null
#
# Indexes
#
#  index_course_programming_labs_on_course_id_and_position  (course_id,position)
#  index_course_programming_labs_on_course_lab_id           (course_id,programming_lab_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (programming_lab_id => programming_labs.id)
#

class CourseProgrammingLab < ApplicationRecord
  belongs_to :course,
    counter_cache: true

  delegate :title,
    to: :course,
    prefix: true

  acts_as_list scope: :course

  has_many :enrollments,
    through: :course

  has_many :students,
    through: :enrollments

  has_many :course_teachers,
    through: :course

  has_many :teachers,
    through: :course_teachers

  belongs_to :programming_lab

  alias_method :lab, :programming_lab

  delegate :title,
    :teacher_notes,
    to: :programming_lab,
    prefix: :lab

  has_many :file_groups,
    through: :programming_lab

  has_many :files,
    through: :file_groups

  has_many :submissions,
    dependent: :restrict_with_exception

  has_many :most_recent_submissions,
    dependent: :restrict_with_exception

  has_many :most_recent_ungraded_submissions,
    -> { ungraded },
    class_name: "MostRecentSubmission",
    dependent: :restrict_with_exception,
    inverse_of: :course_programming_lab

  delegate :count,
    to: :most_recent_ungraded_submissions,
    prefix: :most_recent_ungraded_submissions

  scope :for_course, ->(course) { where(course_id: course.id) }
  scope :for_lab, ->(lab) { where(programming_lab_id: lab.id) }
  scope :reorder_by_course_title, ->(dir = :asc) { joins(:course).merge(Courser.reorder_by_title(dir)) }
  scope :reorder_by_lab_title, ->(dir = :asc) { joins(:programming_lab).merge(ProgrammingLab.reorder_by_title(dir)) }
  scope :enrolls, ->(user) { left_joins(:enrollments).merge(Enrollment.where(student: user)) }
  scope :taught_by, ->(user) { left_joins(:course_teachers).merge(CourseTeacher.where(teacher: user)) }
  scope :course_created_by, ->(user) { joins(:course).merge(Course.created_by(user)) }
  scope :order_by_position, ->(dir = :asc) { order(position: dir) }
  scope :reorder_by_position, ->(dir = :asc) { reorder(position: dir) }

  scope :taught_or_course_created_by, ->(user) do
    left_joins(:course_teachers)
      .joins(:course)
      .where("course_teachers.teacher_id = ? OR courses.creator_id = ?", user.id, user.id)
  end

  scope :submittable, -> { where(submittable: true) }

  def title
    "#{course_title}: #{lab_title}"
  end

  def has_ungraded_submissions?
    most_recent_ungraded_submissions.any?
  end

  def student_emails
    students.pluck(:email)
  end

  def most_recent_submission_authored_by(enrollment:)
    most_recent_submissions.authored_by(enrollment).first
  end
end
