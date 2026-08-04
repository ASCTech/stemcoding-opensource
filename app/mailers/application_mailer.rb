# frozen_string_literal: true

# This is the top level mailer used for managing mail.
class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_SENDER", "no-reply@example.com")
  layout "mailer"
end
