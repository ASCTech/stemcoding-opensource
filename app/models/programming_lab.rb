# frozen_string_literal: true

# == Schema Information
#
# Table name: programming_labs
#
#  id            :integer          not null, primary key
#  content       :text             not null
#  teacher_notes :text
#  template      :boolean          default(FALSE), not null
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  creator_id    :integer          not null
#
# Indexes
#
#  index_programming_labs_on_title  (title) UNIQUE
#

class ProgrammingLab < ApplicationRecord
  belongs_to :creator,
    class_name: "User",
    foreign_key: :creator_id,
    inverse_of: :created_labs

  delegate :complete_name,
    to: :creator,
    prefix: :creator

  has_many :file_groups,
    class_name: "LabFileGroup",
    dependent: :destroy

  accepts_nested_attributes_for :file_groups,
    reject_if: :all_blank,
    allow_destroy: true

  has_many :course_programming_labs,
    inverse_of: :programming_lab,
    dependent: :destroy

  has_many :submissions,
    through: :course_programming_labs

  has_many :courses,
    through: :course_programming_labs

  has_many :students,
    through: :courses,
    source: :students

  has_many :teachers,
    through: :courses,
    source: :teachers

  validates :title,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :content,
    presence: true

  scope :taught_by, ->(user) { joins(:teachers).merge(User.where(id: user.id)) }
  scope :enrolls, ->(user) { joins(:students).merge(User.where(id: user.id)) }
  scope :authored_by, ->(user) { joins(:creator).merge(User.where(id: user.id)) }
  scope :taught_or_authored_by, ->(user) do
    left_joins(:teachers, :creator).merge(User.where(id: user.id).or(where("creators_programming_labs.id = ?", user.id)))
  end
  scope :order_by_title, ->(dir = :asc) { order(title: dir) }
  scope :reorder_by_title, ->(dir = :asc) { reorder(title: dir) }

  def compose
    title
  end

  def taught_by?(user)
    teachers.include?(user)
  end

  def enrolls_student?(user)
    students.include?(user)
  end

  def authored_by?(user)
    creator == user
  end

  def has_submissions?
    submissions.any?
  end
end
