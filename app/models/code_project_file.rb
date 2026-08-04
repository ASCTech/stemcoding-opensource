# frozen_string_literal: true

# == Schema Information
#
# Table name: code_project_files
#
#  id              :integer          not null, primary key
#  content         :text             not null
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  code_project_id :integer          not null
#
# Indexes
#
#  index_code_project_files_on_code_project_id  (code_project_id)
#
# Foreign Keys
#
#  fk_rails_...  (code_project_id => code_projects.id)
#

class CodeProjectFile < ApplicationRecord
  validates :name,
    :content,
    presence: true

  belongs_to :code_project

  def to_tempfile(&block)
    tempfile = Tempfile.new([name, ".js"])
    tempfile.write(content)

    block.call(tempfile) if block.present?

    tempfile
  end
end
