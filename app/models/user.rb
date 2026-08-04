# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  course_teachers_count  :integer          default(0), not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_active_at         :datetime
#  last_name              :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  prefix                 :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  student                :boolean          default(TRUE), not null
#  suffix                 :string
#  super_teacher          :boolean          default(FALSE), not null
#  teacher                :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_admin                 (admin)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_first_name            (first_name)
#  index_users_on_last_name             (last_name)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_student               (student)
#  index_users_on_teacher               (teacher)
#

# This is the model that represents a user of the system.
# It has various state flags such as admin, student, and teacher
# that indicate the specific user's roles and levels of access.
#
# It utilizes devise for authentification.
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :enrollments,
    inverse_of: :student,
    dependent: :destroy,
    foreign_key: :student_id

  has_many :submissions,
    through: :enrollments

  has_many :enrolled_courses,
    through: :enrollments,
    source: :course

  # submissions authored by the user a student in the course
  has_many :student_submissions,
    through: :enrollments,
    source: :submissions

  has_many :course_teachers,
    inverse_of: :teacher,
    foreign_key: :teacher_id,
    dependent: :destroy

  has_many :taught_courses,
    through: :course_teachers,
    class_name: "Course",
    foreign_key: :course_id,
    source: :course

  # submissions authored by the user as a teacher of the course
  has_many :teacher_submissions,
    through: :course_teachers,
    source: :submissions

  has_many :created_courses,
    class_name: "Course",
    foreign_key: :creator_id,
    inverse_of: :creator,
    dependent: :restrict_with_exception

  has_many :enrolled_course_labs,
    through: :enrolled_courses,
    source: :course_programming_labs

  has_many :enrolled_labs,
    class_name: "ProgrammingLab",
    through: :enrolled_courses,
    source: :programming_labs

  has_many :taught_course_labs,
    through: :taught_courses,
    source: :course_programming_labs

  # submissions from courses where user is a teacher
  has_many :taught_submissions,
    through: :taught_course_labs,
    source: :submissions

  has_many :taught_labs,
    class_name: "ProgrammingLab",
    through: :taught_courses,
    source: :programming_labs

  has_many :created_labs,
    class_name: "ProgrammingLab",
    foreign_key: :creator_id,
    inverse_of: :creator,
    dependent: :restrict_with_exception

  has_many :code_projects,
    dependent: :destroy

  has_many :students,
    through: :taught_courses

  has_many :teachers,
    through: :enrolled_courses

  has_many :render_files,
    dependent: :destroy

  validates :first_name,
    :last_name,
    presence: true

  validates :prefix,
    length: { in: 2..20,
             allow_blank: true,  }

  validates :suffix,
    length: { in: 2..20,
             allow_blank: true,  }

  validates :email,
    confirmation: true,
    uniqueness: { case_sensitive: false }

  scope :admins, -> { where(admin: true) }
  scope :teachers, -> { where(teacher: true) }
  scope :order_by_first_name, ->(dir = :asc) { order(first_name: dir) }
  scope :order_by_last_name, ->(dir = :asc) { order(last_name: dir) }
  scope :taught_by, ->(teacher) { joins(:teachers).where("teachers_users.id = ?", teacher.id) }
  scope :teaches_courses, -> { where.not(course_teachers_count: 0) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def complete_name
    rv = full_name

    if prefix.present?
      rv = "#{prefix} #{rv}"
    end

    if suffix.present?
      rv = "#{rv} #{suffix}"
    end

    rv
  end

  def enroll_in_course(join_key)
    if !(course = Course.is_not_template.find_by(join_key: join_key))
      [false, course, "The specified join key of: \'#{join_key}\' does not point to a Course."]
    elsif enrolled_courses.exists? course.id
      [true, course, "You are already enrolled in the course: #{course.title}"]
    else
      enrolled_courses << course
      [true, course, "You are already enrolled in the course: #{course.title}"]
    end
  end

  # Finds the latest submission of this user's in a given programming_lab
  #
  # @return [Submission|NoSubmission] The most recent submission in this lab if
  #                                   one exists. Otherwise, return
  #                                   NoSubmission
  def get_latest_submission(course_lab)
    submissions.find_by(course_programming_lab: course_lab)&.last_descendent || NoSubmission.new
  end

  # Returns true if this user has a submission in the programming lab lab.
  def has_submission_in_lab?(course_lab)
    get_latest_submission(course_lab).present?
  end

  def enrolled_in_course?(course)
    enrolled_courses.include?(course)
  end

  def enrolled_in_lab?(lab)
    enrolled_labs.include?(lab)
  end

  def instructor_for_lab?(lab)
    taught_labs.include?(lab)
  end

  def instructs?(user)
    students.include?(user)
  end

  def taught_by?(user)
    teachers.include?(user)
  end

  def last_weeks_taught_submissions
    taught_submissions
      .last_week
      .reorder_by_created_at
  end
end
