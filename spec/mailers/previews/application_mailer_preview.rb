require "rspec/mocks/standalone"

class ApplicationMailerPreview < ActionMailer::Preview
  include RSpec::Mocks::ExampleMethods
end
