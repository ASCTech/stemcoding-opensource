# == Schema Information
#
# Table name: most_recent_submissions
#
#  id                        :integer
#  author_type               :string
#  grade                     :float
#  instructor_comment        :text
#  student_comment           :text
#  created_at                :datetime
#  updated_at                :datetime
#  author_id                 :integer
#  course_programming_lab_id :integer
#  submission_id             :integer
#

class MostRecentSubmission < ApplicationRecord
  belongs_to :submission

  class << self
    def created_at
      @created_at ||= arel_table[:created_at]
    end
  end

  has_many :files,
    through: :submission

  belongs_to :author,
    polymorphic: true

  delegate :user,
    to: :author

  delegate :taught_by?,
    :full_name,
    to: :user,
    prefix: :author

  belongs_to :course_programming_lab

  delegate :lab_title,
    :submittable?,
    to: :course_programming_lab

  delegate :title,
    to: :course_programming_lab,
    prefix: :course_lab

  alias_method :course_lab, :course_programming_lab

  has_one :course,
    through: :course_programming_lab

  has_one :programming_lab,
    through: :course_programming_lab

  delegate :taught_by?,
    :enrolls_student?,
    to: :programming_lab,
    prefix: :lab

  # unfortunately, you cannot preload/include this assocation
  has_many :previous_submissions,
    through: :submission

  scope :authored_by, ->(author) { where(author: author) }
  scope :reorder_by_created_at, ->(dir = :asc) { reorder(created_at: dir) }
  scope :with_instructor_comment, -> { where.not(instructor_comment: nil) }
  scope :for_course, ->(course) { joins(:course_programming_lab).merge(CourseProgrammingLab.for_course(course)) }
  scope :for_lab, ->(lab) { joins(:course_programming_lab).merge(CourseProgrammingLab.for_lab(lab)) }
  scope :ungraded, -> { where(grade: nil) }
  scope :nonperfect, -> { where.not(grade: nil).where.not(grade: 10.0) }

  def compose
    "#{user.full_name} ##{chain_index}"
  end

  def last_descendent
    course_programming_labs.submissions.authored_by(author).reorder_by_created_at(:desc).first
  end

  alias most_recent last_descendent

  def last_descendent?
    last_descendent == self
  end

  alias most_recent? last_descendent?

  def first_ancestor
    course_programming_labs.submissions.authored_by(author).reorder_by_created_at(:asc).first
  end

  def first_ancestor?
    first_ancestor == self
  end

  def chain_index
    previous_submissions.count + 1
  end

  def graded?
    !!grade
  end

  def ungraded?
    !graded?
  end

  def perfect_grade?
    grade == 10.0
  end

  def nonperfect_grade?
    !perfect_grade?
  end

  def authored_by?(user)
    self.user == user
  end

  def user?
    !!user
  end

  def student_comment?
    !!student_comment
  end

  def instructor_comment?
    !!instructor_comment
  end

  def previous_instructor_comments
    previous_submissions.select(:instructor_comment)
  end
end
