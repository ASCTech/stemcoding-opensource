# frozen_string_literal: true

# == Schema Information
#
# Table name: lab_file_groups
#
#  id                 :integer          not null, primary key
#  downloadable       :boolean          default(FALSE), not null
#  key                :string           not null
#  title              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  programming_lab_id :integer          not null
#
# Indexes
#
#  index_lab_file_groups_on_programming_lab_id_and_key  (programming_lab_id,key) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (programming_lab_id => programming_labs.id) ON DELETE => cascade
#

# This model serves to group programming lab files.
class LabFileGroup < ApplicationRecord
  has_many :files,
    -> { extending(FilesAssociationExtension) },
    class_name: "ProgrammingLabFile",
    dependent: :destroy,
    inverse_of: :lab_file_group

  accepts_nested_attributes_for :files,
    reject_if: :all_blank,
    allow_destroy: true

  belongs_to :programming_lab

  delegate :enrolls_student?,
    :taught_by?,
    :authored_by?,
    to: :programming_lab,
    prefix: :lab

  alias_method :lab, :programming_lab
  alias_attribute :lab_id, :programming_lab_id

  has_many :students,
    through: :programming_lab

  validates :title, presence: true
  validates :key, presence: true

  def has_downloadable_files?
    downloadable? && files.any?
  end
end
