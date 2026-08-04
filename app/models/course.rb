# frozen_string_literal: true

# == Schema Information
#
# Table name: courses
#
#  id                            :integer          not null, primary key
#  course_programming_labs_count :integer          default(0), not null
#  description                   :text             default(""), not null
#  join_key                      :string
#  template                      :boolean          default(FALSE), not null
#  title                         :string           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  creator_id                    :integer          not null
#
# Indexes
#
#  index_courses_on_creator_id  (creator_id)
#  index_courses_on_join_key    (join_key) UNIQUE
#  index_courses_on_template    (template)
#  index_courses_on_title       (title)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#

class Course < ApplicationRecord
  class << self
    def creator_id
      @creator_id ||= arel_table[:creator_id]
    end
  end

  belongs_to :creator,
    class_name: "User",
    foreign_key: :creator_id,
    inverse_of: :created_courses

  has_many :course_teachers,
    dependent: :destroy

  has_many :teachers,
    through: :course_teachers

  has_many :course_programming_labs,
    dependent: :destroy

  accepts_nested_attributes_for :course_programming_labs,
    allow_destroy: true

  alias_method :course_labs, :course_programming_labs
  alias_attribute :course_labs_count, :course_programming_labs_count

  has_many :submissions,
    through: :course_programming_labs

  has_many :most_recent_ungraded_submissions,
    through: :course_programming_labs

  delegate :count,
    to: :most_recent_ungraded_submissions,
    prefix: :most_recent_ungraded_submissions

  has_many :programming_labs,
    through: :course_programming_labs

  alias_method :labs, :programming_labs

  has_many :enrollments,
    inverse_of: :course,
    dependent: :destroy

  has_many :students,
    through: :enrollments,
    class_name: "User",
    foreign_key: :student_id

  validates :title, presence: true
  validates :description, presence: true
  validates :join_key, uniqueness: true

  validates :creator, presence: true

  scope :taught_by, ->(user) { joins(:teachers).merge(User.where(id: user.id)) }
  scope :created_by, ->(user) { where(creator: user) }
  scope :taught_or_created_by, ->(user) do
    includes(:course_teachers)
      .references(:course_teachers)
      .where(CourseTeacher.teacher_id.eq(user.id).or(Course.creator_id.eq(user.id)))
  end
  scope :enrolls, ->(user) { joins(:students).merge(User.where(id: user.id)) }
  scope :is_template, -> { where(template: true) }
  scope :is_not_template, -> { where(template: false) }
  scope :order_by_title, ->(dir = :asc) { order(title: dir) }
  scope :reorder_by_title, ->(dir = :asc) { reorder(title: dir) }
  scope :with_join_key, ->(join_key) { where(join_key: join_key) }
  scope :with_at_least_one_lab, -> { where.not(course_programming_labs_count: 0) }

  def compose
    template? ? "[TEMPLATE] #{title}" : title
  end

  # This returns a "join_key" that can be used by a course.
  # (Random 20 character long string.)
  #
  # @return [String] A 20 character random join key.
  def gen_key
    SecureRandom.hex[0..19]
  end

  # This generates a new join_key for this course.
  #
  # @return [String] The new join key for the course.
  def gen_key!
    self.join_key = gen_key
  end

  def gen_key_if_empty!
    gen_key! if join_key.blank?
  end

  # This clones the current course to create a new non-template course.
  #
  # @param title The title of the new course
  # @param teacher The teacher of the new course
  #
  # @return [Course] A clone of this course (but not saved to the database).
  def clone(title:, teacher:)
    Course.new(
      title: title,
      description: description,
      creator: creator
    ).tap do |course|
      course.gen_key!
      course.teachers << teacher
      course.programming_labs = programming_labs
    end
  end

  def taught_by?(user)
    teachers.include?(user)
  end

  def created_by?(user)
    creator == user
  end

  def taught_or_created_by?(user)
    taught_by?(user) || created_by?(user)
  end

  def has_ungraded_submissions?
    most_recent_ungraded_submissions.any?
  end

  def has_submissions?
    submissions.any?
  end
end
