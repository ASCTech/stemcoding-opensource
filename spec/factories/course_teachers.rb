# frozen_string_literal: true

FactoryBot.define do
  factory :course_teacher do
    course
    association :teacher, factory: :teacher
  end
end
