# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :student do
      student { true }
    end

    trait :teacher do
      teacher { true }
    end

    trait :super_teacher do
      super_teacher { true }
    end

    trait :admin do
      admin { true }
    end

    factory :student, traits: %i[student]
    factory :teacher, traits: %i[teacher]
    factory :super_teacher, traits: %i[super_teacher]
    factory :admin, traits: %i[admin]
  end
end
