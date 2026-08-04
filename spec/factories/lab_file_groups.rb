# frozen_string_literal: true

FactoryBot.define do
  factory :lab_file_group, aliases: %i[file_group] do
    title { Faker::Book.title }
    key { SecureRandom.hex(20) }

    trait :downloadable do
      downloadable { true }
    end

    trait :nondownloadable do
      downloadable { false }
    end

    factory :downloadable_file_group, traits: %i[downloadable]
    factory :nondownloadable_file_group, traits: %i[nondownloadable]
  end
end
