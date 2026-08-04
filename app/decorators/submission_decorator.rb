# frozen_string_literal: true

class SubmissionDecorator < ApplicationDecorator
  delegate_all

  # @return This returns a formatted version of the submissions title.
  def formatted_title
    "#{current_user.full_name} = #{h.truncate(object.student_comment, length: 20)}"
  end

  def created_at
    submission.created_at.localtime.to_s
  end

  def grade
    submission.graded? ? submission.grade.to_s : "Not graded"
  end

  private

    def submission
      object
    end
end
