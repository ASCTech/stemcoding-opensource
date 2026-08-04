# frozen_string_literal: true

require "rails_helper"

describe ProgrammingLabFile do
  describe "Associations" do
    it { should belong_to(:lab_file_group) }
  end

  describe "database" do
    it { should have_db_column(:file).of_type(:string) }
    it { should have_db_column(:lab_file_group_id).of_type(:integer) }
  end

  describe "validation" do
    # Presence of
    it { should validate_presence_of(:file) }
  end
end
