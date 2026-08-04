# frozen_string_literal: true

require "rails_helper"

describe RenderFile do
  describe "association" do
    it { should belong_to(:user) }
  end

  describe "database" do
    it { should have_db_column(:expires).of_type(:datetime) }
    it { should have_db_column(:content).of_type(:text) }
    it { should have_db_column(:name).of_type(:string) }
  end

  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:expires) }
  end

  describe "attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:content) }
    it { should respond_to(:expires) }
  end
end
