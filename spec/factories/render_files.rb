# frozen_string_literal: true

FactoryBot.define do
  factory :render_file do
    expires { Faker::Time.between(from: Time.zone.now, to: 2.days.from_now) }
    content { Faker::Lorem.paragraphs(number: 5) }
    name { Faker::Name.name.parameterize.underscore }

    user
  end
end
