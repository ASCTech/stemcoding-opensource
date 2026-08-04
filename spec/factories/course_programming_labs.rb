# frozen_string_literal: true

FactoryBot.define do
  factory :course_programming_lab, aliases: %i[course_lab] do
    course
    programming_lab

    trait :open_to_submissions do
      submittable { true }
    end

    trait :closed_to_submissions do
      submittable { false }
    end

    factory :submittable_course_lab, traits: %i[open_to_submissions]
    factory :closed_course_lab, traits: %i[closed_to_submissions]
  end
end
