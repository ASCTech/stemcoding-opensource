# frozen_string_literal: true

# == Schema Information
#
# Table name: code_projects
#
#  id          :integer          not null, primary key
#  description :text             default(""), not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_code_projects_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

# A code project isn't tied to a programming lab. Instead, it is intended to
# serve as a blank slate to allow students to experiment with code. Later, if
# the student decides they want to submit the code to a programming lab, they
# can attach it to a new submission.
class CodeProject < ApplicationRecord
  has_many :code_project_files,
    dependent: :destroy

  alias_method :files, :code_project_files

  belongs_to :user

  validates :name, presence: true

  def gen_signed_message
    verifier = ActiveSupport::MessageVerifier.new(Rails.application.credentials.secret_key_base)
    # Including user_id to verify that the correct user is submitting.
    message = { code_project_id: id, code_project: true, expires: Time.zone.now + 1.day }

    verifier.generate(message)
  end

  def owned_by?(user)
    self.user == user
  end

  def submission_files
    code_project_files.map do |file|
      tf = Tempfile.new(file.name)
      tf.write(file.content)

      SubmissionFile.new(file: tf)
    end
  end
end
