# frozen_string_literal: true

# == Schema Information
#
# Table name: programming_lab_files
#
#  id                :integer          not null, primary key
#  file              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  lab_file_group_id :integer          not null
#
# Indexes
#
#  index_programming_lab_files_on_lab_file_group_id  (lab_file_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (lab_file_group_id => lab_file_groups.id)
#

# This model represents a single file attached to a specific programming lab
# via a LabFileGroup.
class ProgrammingLabFile < ApplicationRecord
  belongs_to :lab_file_group,
    inverse_of: :files

  delegate :downloadable?,
    to: :lab_file_group

  has_one :programming_lab,
    through: :lab_file_group

  delegate :enrolls_student?,
    :taught_by?,
    :authored_by?,
    to: :programming_lab,
    prefix: :lab

  mount_uploader :file, ProgrammingLabUploader

  validates :file, presence: true
end
