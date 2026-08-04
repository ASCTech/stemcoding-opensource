# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ADMIN_EMAIL = "admin@example.com"

[
  [ADMIN_EMAIL, "Admin", "Example"],
  %w[teacher@example.com Teacher Example],
].each do |email, last_name, first_name|
  user = User.admins.find_or_initialize_by(email: email) { |u|
    u.last_name = last_name
    u.first_name = first_name
    u.password = SecureRandom.hex
  }

  user.save! if user.email_changed?

  pp user
end

if Rails.env.development?
  u = User.find_by!(email: ADMIN_EMAIL)
  u.teacher = true

  u.password = ENV.fetch("SEED_ADMIN_PASSWORD", "password")

  u.save!

  courses = FactoryBot.create_list(:course_teacher, 3, teacher: u).map(&:course)

  course_labs = courses.flat_map do |course|
    FactoryBot.create_list(:course_lab, 3, course: course)
  end

  pp courses
  pp course_labs
end
