# frozen_string_literal: true

require "rails_helper"

describe "Player", js: true do
  it "does something" do
    admin = create(:admin)

    login_as admin

    draw_code_render_file
    canvas_code_render_file

    visit_player(player_path(query: encoded_message))
  end

  private

    def verifier
      @verifier ||= ActiveSupport::MessageVerifier.new(Rails.application.credentials.secret_key_base)
    end

    def draw_code
      <<~CODE
        function draw() {
        \tif (mouseIsPressed) {
        \t\tfill(0);
        \t} else {
        \t\tfill(255);
        \t}
        \tellipse(mouseX, mouseY, 80, 80);
        } // end draw()
      CODE
    end

    def draw_code_render_file
      @draw_code_render_file ||= create(
        :render_file,
        name: "sketch.js",
        content: draw_code
      )
    end

    def canvas_code
      <<~JS
        function setup() {
        \tcreateCanvas(750, 500);
        }
      JS
    end

    def canvas_code_render_file
      @canvas_code_render_file ||= create(
        :render_file,
        name: "canvas.js",
        content: canvas_code
      )
    end

    def encoded_message
      verifier.generate({ ids: [canvas_code_render_file.id, draw_code_render_file.id] })
    end
end
