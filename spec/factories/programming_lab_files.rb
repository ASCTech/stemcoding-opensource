# frozen_string_literal: true

FactoryBot.define do
  factory :programming_lab_file do
    file { Rack::Test::UploadedFile.new(File.open("spec/support/files/sketch.js")) }
  end
end
