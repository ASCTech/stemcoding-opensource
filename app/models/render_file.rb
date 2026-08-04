# frozen_string_literal: true

# == Schema Information
#
# Table name: render_files
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  expires    :datetime         not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => nullify
#

# This model represents code snippets being sent to the p5 player.
class RenderFile < ApplicationRecord
  validates :name, presence: true
  validates :expires, presence: true

  # contains the actual code snippet
  validates :content,
    presence: true

  belongs_to :user

  def to_tempfile(&block)
    tempfile = Tempfile.new([name, ".js"])
    tempfile.write(content)

    block.call(tempfile) if block.present?

    tempfile
  end
end
