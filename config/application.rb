require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StemCoding
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.active_job.queue_adapter = :sidekiq

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.containerized = false
    config.tinymce.install = :copy

    [
      Rails.root.join("lib").to_s,
    ].each do |path|
      config.autoload_paths << path
      config.eager_load_paths << path
    end

    config.action_mailer.default_url_options = {
      host: "localhost",
    }

    config.action_mailer.preview_paths = [Rails.root.join("spec", "mailers", "previews")]
  end
end
