# frozen_string_literal: true

require "rails_helper"

describe CodeProject do
  describe "database" do
    it { should have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:description).of_type(:text).with_options(null: false, default: "") }
  end
  describe "validations" do
    it { should validate_presence_of(:name) }
  end
  describe "associations" do
    it { should have_many(:code_project_files).dependent(:destroy) }
    it { should belong_to(:user) }
  end
  describe "instance methods" do
    describe "#gen_signed_message" do
      let(:user) { create(:user) }
      let(:code_project) { create(:code_project, user: user) }

      it "properly generates the message" do
        verifier = ActiveSupport::MessageVerifier.new(Rails.application.credentials.secret_key_base)
        query = code_project.gen_signed_message
        result = verifier.verify(query)

        expect(result[:code_project]).to be true
        expect(result[:code_project_id]).to eq code_project.id
      end
    end
  end
end
