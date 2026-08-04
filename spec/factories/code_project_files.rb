# frozen_string_literal: true

FactoryBot.define do
  factory :code_project_file do
    name { Faker::Zelda.character }
    content { Faker::Lorem.paragraphs(10).join("\n") }
    code_project_id { 1 }
  end
end
