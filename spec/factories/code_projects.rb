# frozen_string_literal: true

FactoryBot.define do
  factory :code_project do
    name { Faker::Movies::LordOfTheRings.character }
    description { Faker::Lorem.paragraphs(number: 5).join("\n") }
  end
end
