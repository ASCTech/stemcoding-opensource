# frozen_string_literal: true

FactoryBot.define do
  factory :submission do
    course_programming_lab

    association :author, factory: :enrollment

    trait :graded do
      grade { rand(10) }
    end

    trait :ungraded do
      grade { nil }
    end

    student_comment { "Student comment" }
    instructor_comment { "Instructor comment" }

    trait :with_instructor_comment do
      sequence(:instructor_comment) { |n| "Instructor comment #{n}" }
    end

    factory :graded_submission, traits: %i[graded]
    factory :ungraded_submission, traits: %i[ungraded]
  end
end
