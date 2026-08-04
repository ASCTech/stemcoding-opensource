# frozen_string_literal: true

FactoryBot.define do
  factory :programming_lab, aliases: %i[lab] do
    sequence(:title) { |n| "#{Faker::Book.title} #{n}" }
    content { "$$\\frac{a}{b}$$" }
    teacher_notes { Faker::Lorem.paragraph }
    association :creator, factory: :user
  end
end
