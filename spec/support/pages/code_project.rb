module Page
  class CodeProject
    include Rails.application.routes.url_helpers
    include Capybara::DSL

    attr_reader :name, :description

    def initialize(name:, description:)
      @name = name
      @description = description
    end

    def create
      click_on "Sandbox"

      # The student "Save Project" button opens the new-project form in a new
      # window (see IdesHelper#save_button, new_window: true), so switch to it.
      new_window = window_opened_by { find("#save-project").click }
      switch_to_window(new_window)

      fill_in "Project name", with: name

      within_frame(code_project_description_iframe) do
        find("body[data-id='code_project_description']").set(description)
      end

      click_on "Save Project"
    end

    def has_success_notification?
      notification.has_content?("Code project, #{name}, created.")
    end

    def has_project?
      code_projects.has_content?(name) && code_projects.has_content?(description)
    end

    private

      def code_projects
        find("#code-projects")
      end

      def notification
        find(".alert-notice")
      end

      def code_project_description_iframe
        find("#code_project_description_ifr")
      end
  end
end
