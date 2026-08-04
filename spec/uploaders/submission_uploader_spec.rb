# frozen_string_literal: true

require "rails_helper"

describe SubmissionUploader do
  include CarrierWave::Test::Matchers
  let(:student) { instance_double(User, id: 1) }
  subject(:uploader) { SubmissionUploader.new(student) }

  before do
    SubmissionUploader.enable_processing = true
    File.open("spec/fixtures/sketch___RandomGeneratedirj3295u8934ru89qur4qrq4___.js") { |f| uploader.store!(f) }
  end

  after do
    SubmissionUploader.enable_processing = false
    uploader.remove!
  end

  # it "has the correct whitelist" do
  #   expect(uploader.extension_allowlist).to eq ["js"]
  # end

  it "has some content" do
    expect(uploader.read).not_to be_empty
  end

  #  it "has correct filename" do
  #    expect(uploader.filename).to eq "sketch.js"
  #  end
end
