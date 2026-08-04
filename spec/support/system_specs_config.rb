if Rails.application.config.containerized
  Capybara.register_driver :selenium_chrome_headless do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless=new")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1400,1400")

    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 90

    Capybara::Selenium::Driver.new(app,
      browser: :remote,
      url: ENV.fetch("SELENIUM_URL", "http://selenium:4444/wd/hub"),
      options: options,
      http_client: client)
  end

  Capybara.javascript_driver = :selenium_chrome_headless
else
  Capybara.register_driver :chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new

    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  Capybara.javascript_driver = :chrome
end

Capybara.server = :puma
Capybara.configure do |config|
  config.always_include_port = true
  # System specs run against a separate browser container and build JS assets
  # on demand, so give async interactions a generous default wait.
  config.default_max_wait_time = 10
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    if Rails.application.config.containerized
      driven_by :selenium_chrome_headless

      # The test Puma server runs in this container; the Selenium browser runs
      # in a separate container and must reach us over the shared Docker
      # network, so bind to this container's IP rather than localhost.
      ip = `hostname -I`.strip.split.first

      Capybara.server_port = "4000"
      Capybara.server_host = ip
      Capybara.app_host = "http://#{ip}:4000"
    else
      driven_by :chrome
    end
  end
end
