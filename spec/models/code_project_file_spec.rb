# frozen_string_literal: true

require "rails_helper"

describe CodeProjectFile do
  describe "database" do
    it { should have_db_column(:code_project_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:content).of_type(:text).with_options(null: false) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:content) }
  end

  describe "associations" do
    it { should belong_to(:code_project) }
  end
end
