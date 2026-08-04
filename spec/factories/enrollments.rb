# frozen_string_literal: true

FactoryBot.define do
  factory :enrollment do
    course
    association :student, factory: :student
  end
end
