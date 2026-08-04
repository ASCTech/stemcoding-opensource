# frozen_string_literal: true

# This controller allows a student to view their gradebook for a course
class Student::Courses::GradebooksController < StudentsController
  def show
    set_course
    set_course_labs
    set_enrollment

    authorize @course
  end

  private

    def course_id
      params.require(:course_id)
    end

    def set_course
      @course ||= ::Course.includes(course_programming_labs: :programming_lab).find(course_id)
    end

    def set_course_labs
      set_course
      @course_labs ||= @course.course_programming_labs.reorder_by_position
    end

    def set_enrollment
      @enrollment ||= current_user.enrollments.find_by!(course: @course)
    end
end
