# frozen_string_literal: true

require "rails_helper"

describe LabFileGroup do
  it { should have_many(:files).class_name("ProgrammingLabFile") }
  it { should belong_to(:programming_lab) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:key) }
end
