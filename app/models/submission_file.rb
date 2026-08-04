# frozen_string_literal: true

# == Schema Information
#
# Table name: submission_files
#
#  id            :integer          not null, primary key
#  file          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  submission_id :integer          not null
#
# Foreign Keys
#
#  fk_rails_...  (submission_id => submissions.id) ON DELETE => cascade
#

# This model represents a file uploaded and attached to a submission.
class SubmissionFile < ApplicationRecord
  belongs_to :submission,
    inverse_of: :files

  delegate :authored_by?,
    to: :submission,
    prefix: :submission

  has_one :user,
    through: :submission

  has_one :programming_lab,
    through: :submission

  delegate :enrolls_student?,
    :taught_by?,
    :authored_by?,
    to: :programming_lab,
    prefix: :lab

  mount_uploader :file, SubmissionUploader

  validates :file, presence: true
end
