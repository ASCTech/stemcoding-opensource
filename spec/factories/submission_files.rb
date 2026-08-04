# frozen_string_literal: true

FactoryBot.define do
  factory :submission_file do
    submission

    file { Rack::Test::UploadedFile.new(File.join(Dir.pwd, "spec", "fixtures", "sketch.js")) }
  end
end
