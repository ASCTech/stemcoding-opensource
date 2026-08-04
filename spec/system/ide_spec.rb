# frozen_string_literal: true

require "rails_helper"

describe "ide", js: true do
  it "does something" do
    admin = create(:admin)

    login_as admin

    click_on "Sandbox"
  end
end
