require "./spec/support/system_helper"
require 'rails_helper'

module Page
  module Student
    class Submission
      include SystemHelper
      include Rails.application.routes.url_helpers
      include Capybara::DSL

      attr_reader :enrollment,
        :course_lab,
        :student_comment

      def initialize(enrollment:, course_programming_lab:, student_comment:)
        @enrollment = enrollment
        @course_lab = course_programming_lab
        @student_comment = student_comment
      end

      def start
        visit student_dashboard_path
        click_on "Sandbox"
      end

      def fill_in_form
        # The student "Save Project" button opens the form in a new window.
        new_window = window_opened_by { find("#save-project").click }
        switch_to_window(new_window)
        fill_in "Project name", with: "Project name"
        fill_in_rich_text "Description", with: "Description"

        click_on "Save Project"
        click_on "Submit"
        choose course_lab.title
        fill_in "Comments", with: student_comment
      end

      def create
        start

        fill_in_form

        click_on "Submit Project"
      end

      def view
        visit student_course_programming_lab_submissions_path(course_lab)

        submission_link.click
      end

      def has_success_notification?
        notification.has_content?("Code project submitted for programming lab, #{course_lab.title}")
      end

      def has_student_comment?
        page.has_content?(student_comment)
      end

      def has_previous_instructor_comments?(comment)
        instructor_comments.has_content?(comment)
      end

      private

        def notification
          find(".alert-notice")
        end

        def submission_link
          find("#submissions .submission:first-child")
        end

        def instructor_comments
          find("#instructor-comments")
        end
    end
  end
end
