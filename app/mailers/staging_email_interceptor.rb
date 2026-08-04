class StagingEmailInterceptor
  def self.delivering_email(message)
    # Redirect all staging email to a single inbox if configured, so staging
    # never emails real users. No-op when the env var is unset.
    intercept = ENV["STAGING_INTERCEPT_EMAIL"]
    message.to = [intercept] if intercept.present?
  end
end
