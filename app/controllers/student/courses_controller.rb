# frozen_string_literal: true

# This controller allows a student to access their enrolled courses.
class Student::CoursesController < StudentsController
  def index
    @courses = policy_scope(::Course.all).reorder_by_created_at(:desc)
    authorize ::Course.new
  end

  def show
    @course = current_user.enrolled_courses
      .includes(course_programming_labs: :programming_lab)
      .find(params[:id])
    @course_labs = @course.course_programming_labs.reorder_by_position
    authorize @course

    @course = @course.decorate
  end
end
