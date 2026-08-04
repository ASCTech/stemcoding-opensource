# frozen_string_literal: true
Rails.application.configure do
  if Rails.env.staging?
    config.action_mailer.interceptors = %w[StagingEmailInterceptor]
  end
  if Rails.env.development?
    config.action_mailer.interceptors = %w[DevelopmentEmailInterceptor]
  end
end
