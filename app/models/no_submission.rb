# frozen_string_literal: true

class NoSubmission
  def graded?
    false
  end

  def grade
    "Not graded"
  end

  def present?
    false
  end
end
