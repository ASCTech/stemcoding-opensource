# frozen_string_literal: true

module SystemHelper
  def visit_app(path = "/")
    @app_subdomain ||= Rails.application.credentials.subdomain.fetch(:app).fetch(Rails.env.to_sym)

    app_host = URI.join("http://#{@app_subdomain}.lvh.me", path).to_s

    using_app_host(app_host) do
      visit path
    end
  end

  def visit_player(path = "/")
    @player_subdomain ||= Rails.application.credentials.subdomain.fetch(:player).fetch(Rails.env.to_sym)

    app_host = URI.join("http://#{@player_subdomain}.lvh.me").to_s

    using_app_host(app_host) do
      visit path
    end
  end

  def login_as(user)
    visit root_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
    # With a JS driver, click_on returns before the login round-trip finishes.
    # Wait for the authenticated page so a following `visit` doesn't race an
    # unauthenticated request (which would 401 and redirect to the dashboard).
    expect(page).to have_no_field("Password", wait: 15)
  end

  def logout
    click_on "Sign Out"
  end

  def fill_in_rich_text(label, with:)
    tableized_label = label.split(" ").map(&:capitalize).join.underscore
    ta = find("textarea", id: /.+#{tableized_label}/, visible: false)

    id = ta[:id]

    iframe = find("##{id}_ifr")

    within_frame(iframe) do
      rich_text_body = find("body[data-id='#{id}']")

      rich_text_body.set(with)
    end
  end

  def using_app_host(host)
    original_host = Capybara.app_host
    Capybara.app_host = host
    yield
  ensure
    Capybara.app_host = original_host
  end
end
