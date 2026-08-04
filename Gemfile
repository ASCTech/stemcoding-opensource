# frozen_string_literal: true

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# This is the source of the gems.
source "https://rubygems.org"

gem "rails", "~> 7.2", ">= 7.2.3.1"
gem "sprockets-rails", "~> 3.5"

gem "pg", "~> 1.5.9"

gem "haml-rails", "~> 2.0"
gem "sassc-rails"
gem "coffee-rails", "~> 5.0"

gem "devise", "~> 5.0"
gem "pundit", "~> 2.0"
gem "simple_form", "~> 5.0"
gem "responders", "~> 3.0"
gem "cocoon", "~> 1.2"
gem "draper", "~> 4.0"
gem "kaminari", "~> 1.0"

gem "carrierwave", "~> 2.0"

gem "rubyzip", "~> 2.0"

gem "bootsnap", ">= 1.1.0", require: false

gem "jbuilder", "~> 2.8"
gem "sdoc", "~> 1.0", group: :doc

gem "paranoia", "~> 3.0"
gem "acts_as_list", "~> 1.0"
gem "scenic", "~> 1.5"

gem "health_check"

gem "pry-rails"
gem "puma", "~> 8.0"
gem "psych", "~> 3.3"

gem "sidekiq"
gem "whenever", require: false

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console"
  gem "listen"

  gem "better_errors"
  gem "binding_of_caller"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-commands-rspec"

  gem "foreman", require: false
  gem "annotate"

  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "rubycritic", require: false
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false

  gem "bullet"
  gem "traceroute"

  gem "ed25519", "~> 1.4"
  gem "bcrypt_pbkdf", "~> 1.1"
end

group :test do
  gem "simplecov", require: false
  gem "capybara"
  gem "selenium-webdriver"
  # gem "webdrivers", require: false
end

group :development, :test do
  gem "rspec-rails"
  gem "shoulda-matchers"
end

# Allow access to generating fake data on staging server.
group :development, :test, :staging do
  gem "factory_bot_rails"
  gem "faker"
end

gem "vite_rails", "~> 3.0"
gem "tinymce-rails", "~> 8.3.2"

gem "byebug", "~> 12.0"
gem "nokogiri", force_ruby_platform: true