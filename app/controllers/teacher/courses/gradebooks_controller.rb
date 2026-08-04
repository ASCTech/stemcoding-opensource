# frozen_string_literal: true

class Teacher::Courses::GradebooksController < TeachersController
  def show
    set_course
    set_enrollments
    set_course_labs

    authorize :gradebook, :show?
  end

  private

    def course_id
      params.require(:course_id)
    end

    def set_course
      @course ||= begin
        ::Course.includes(
          course_programming_labs: :programming_lab,
          enrollments: %i[submissions student]
        ).find(course_id)
      end
    end

    def set_enrollments
      @enrollments ||= @course.enrollments.joins(:student).merge(User.order_by_last_name)
    end

    def set_course_labs
      @course_labs ||= @course.course_programming_labs.reorder_by_position
    end
end
