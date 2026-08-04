require "./spec/support/system_helper"

module Page
  module Teacher
    class Course
      include Rails.application.routes.url_helpers
      include Capybara::DSL
      include SystemHelper

      attr_reader :title, :description

      def initialize(title:, description:)
        @title = title
        @description = description
      end

      def create
        click_on "Create course"

        fill_in "Title", with: title

        fill_in_rich_text "Description", with: description

        click_on "Create Course"
      end

      def update_title(updated_title)
        visit teacher_dashboard_path

        click_on title
        click_on "Edit"
        fill_in "Title", with: updated_title
        click_on "Update Course"

        @title = updated_title
      end

      def has_created_notification?
        notification.has_content?("Course, #{title}, has been created.")
      end

      def has_course_title?
        page.has_content?(title)
      end

      def has_updated_notification?
        notification.has_content?("Successfully updated course, #{title}.")
      end

      private

        def courses
          find("#courses")
        end

        def notification
          find(".alert-notice")
        end
    end
  end
end
