# frozen_string_literal: true

# == Schema Information
#
# Table name: submissions
#
#  id                        :integer          not null, primary key
#  author_type               :string           not null
#  grade                     :float
#  instructor_comment        :text             default(""), not null
#  student_comment           :text             default(""), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  author_id                 :integer          not null
#  course_programming_lab_id :integer          not null
#
# Indexes
#
#  index_submissions_on_author_type_and_author_id  (author_type,author_id)
#  index_submissions_on_course_programming_lab_id  (course_programming_lab_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_programming_lab_id => course_programming_labs.id)
#

# This is the model that represents a single student submission.
class Submission < ApplicationRecord
  class << self
    def created_at
      @created_at ||= arel_table[:created_at]
    end
  end

  has_many :files,
    -> { extending(FilesAssociationExtension) },
    class_name: "SubmissionFile",
    inverse_of: :submission,
    dependent: :destroy

  accepts_nested_attributes_for :files,
    reject_if: :all_blank,
    allow_destroy: true

  belongs_to :author,
    polymorphic: true

  delegate :user,
    to: :author

  delegate :taught_by?,
    :full_name,
    :email,
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

  delegate :title,
    to: :course,
    prefix: true

  has_one :programming_lab,
    through: :course_programming_lab

  delegate :taught_by?,
    :enrolls_student?,
    to: :programming_lab,
    prefix: :lab

  has_many :enrollments,
    through: :course_programming_lab

  # unfortunately, you cannot preload/include this assocation
  has_many :previous_submissions,
    ->(sub = self) { where(created_at.lt(sub.created_at || Time.zone.now)).authored_by(sub.author) },
    through: :course_programming_lab,
    source: :submissions

  validates :grade, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :course_programming_lab, presence: true

  scope :authored_by, ->(author) { where(author: author) }
  scope :with_instructor_comment, -> { where.not(instructor_comment: nil) }
  scope :for_course, ->(course) { joins(:course_programming_lab).merge(CourseProgrammingLab.for_course(course)) }
  scope :for_lab, ->(lab) { joins(:course_programming_lab).merge(CourseProgrammingLab.for_lab(lab)) }
  scope :ungraded, -> { where(grade: nil) }
  scope :nonperfect, -> { where.not(grade: nil).where.not(grade: 10.0) }
  scope :last_week, -> { where(created_at: 1.week.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :reorder_by_course_title, -> { joins(:course).merge(Course.reorder_by_title) }
  scope :order_by_lab_title, -> { joins(:programming_lab).merge(ProgrammingLab.reorder_by_title) }

  def compose
    "#{user.full_name} ##{chain_index}"
  end

  def last_descendent
    course_programming_lab
      .submissions
      .authored_by(author)
      .reorder_by_created_at(:desc)
      .limit(1)
      .first
  end

  alias most_recent last_descendent

  def last_descendent?
    last_descendent == self
  end

  alias most_recent? last_descendent?

  def first_ancestor
    course_programming_lab
      .submissions
      .authored_by(author)
      .reorder_by_created_at(:asc)
      .limit(1)
      .first
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

  def build_from_render_files(render_files)
    render_files.map do |render_file|
      tf = Tempfile.new(render_file.name)
      tf.write(render_file.content)
      
      self.files << SubmissionFile.new(file: tf)
    end
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
