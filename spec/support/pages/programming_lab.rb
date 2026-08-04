module Page
  class ProgrammingLab
    include Rails.application.routes.url_helpers
    include Capybara::DSL

    attr_reader :title, :teacher_notes

    def initialize(title:, content:, teacher_notes:)
      @title ||= title
      @content ||= content
      @teacher_notes ||= teacher_notes
    end

    def start_lab(as:)
      case as
      when :super_teacher
        visit root_path

        click_on "Teacher"
        click_on "Create Lab"
      when :admin
        visit root_path
      end
    end

    def add_file_group(title:, key:, file_paths:)
    end
  end
end
