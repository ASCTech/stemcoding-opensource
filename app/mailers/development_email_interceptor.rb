class DevelopmentEmailInterceptor
  def self.delivering_email(message)
    message.to = [ENV.fetch("DEV_INTERCEPT_EMAIL", "dev@example.com")]
  end
end
