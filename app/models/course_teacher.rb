# frozen_string_literal: true

# == Schema Information
#
# Table name: course_teachers
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :integer          not null
#  teacher_id :integer          not null
#
# Indexes
#
#  index_course_teachers_on_course_teacher_id  (course_id,teacher_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (teacher_id => users.id)
#

class CourseTeacher < ApplicationRecord
  class << self
    def teacher_id
      @teacher_id ||= arel_table[:teacher_id]
    end
  end

  belongs_to :course

  has_many :course_programming_labs,
    through: :course

  has_many :student_submissions,
    through: :course_programming_labs,
    source: :submissions

  has_many :student_submissions_from_last_week,
    -> { last_week },
    through: :course_programming_labs,
    source: :submissions

  belongs_to :teacher,
    class_name: "User",
    foreign_key: :teacher_id,
    inverse_of: :course_teachers,
    counter_cache: true

  alias_method :user, :teacher

  delegate :email,
    to: :teacher

  has_many :submissions,
    as: :author,
    inverse_of: :author,
    dependent: :restrict_with_exception

  has_many :most_recent_submissions,
    as: :author,
    inverse_of: :author,
    dependent: :restrict_with_exception
end
