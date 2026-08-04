
Sidekiq.configure_server do |config|
  config.redis = {
    url: Rails.application.credentials.redis.fetch(Rails.env.to_sym).fetch(:url),
    password: Rails.application.credentials.redis.fetch(Rails.env.to_sym).fetch(:password),
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: Rails.application.credentials.redis.fetch(Rails.env.to_sym).fetch(:url),
    password: Rails.application.credentials.redis.fetch(Rails.env.to_sym).fetch(:password),
  }
end

if Rails.env.in?(%w[development test])
  require "sidekiq/testing"
  Sidekiq::Testing.inline!
end
