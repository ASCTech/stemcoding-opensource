module Page
  module Teacher
    class Course
      class Gradebook
        include Rails.application.routes.url_helpers
        include Capybara::DSL

        attr_reader :course, :submission, :updated_grade

        def initialize(course:, submission:, updated_grade: rand(1..10))
          @course = course
          @submission = submission
          @updated_grade = updated_grade
        end

        def grade_submission
          click_on course.title
          click_on "Gradebook"

          within(find("##{submission.author_type.parameterize}-#{submission.author_id}")) do
            click_on submission.decorate.grade
          end

          fill_in "Grade", with: updated_grade

          click_on "Submit Grade and Comment"
        end

        def has_updated_grade?(for_submission:)
          gradebook_entry(for_submission: for_submission).has_content?(updated_grade)
        end

        def has_notification?
          notification.has_content?("#{submission.author_full_name}'s grade for #{submission.lab_title} updated.")
        end

        private

          def gradebook_entry(for_submission:)
            sub = for_submission
            find("#enrollment-#{sub.author_id}-course-lab-#{sub.course_programming_lab_id}-submission")
          end

          def notification
            find(".alert-notice")
          end
      end
    end
  end
end
