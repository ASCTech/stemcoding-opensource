# frozen_string_literal: true

require "rails_helper"

describe SubmissionFile do
  it { should belong_to(:submission) }

  it { should validate_presence_of(:file) }
end
