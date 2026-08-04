# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    sequence(:title) { |n| "#{Faker::Book.title} #{n}" }
    description { Faker::Hipster.paragraphs.join("\n") }
    association :creator, factory: :user
    join_key { SecureRandom.hex(20) }

    trait :is_template do
      template { true }
    end

    factory :course_template, traits: %i[is_template]
  end
end
