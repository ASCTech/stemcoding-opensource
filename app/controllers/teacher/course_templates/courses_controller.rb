# frozen_string_literal: true

# Create/clone courses based on the parent course template.
class Teacher::CourseTemplates::CoursesController < TeachersController
  def new
    set_course_template

    @course = Course.new

    authorize @course

    @templates = policy_scope(Course.is_template).map { |c| [c.compose, c.id] }
  end

  def create
    set_course_template

    @course = @course_template.clone(
      title: course_params.require(:title),
      teacher: current_user
    )

    authorize @course

    if @course.save
      flash[:notice] = "Cloned course, #{@course.compose}, from template: #{@course_template.compose}"
    else
      flash[:error] = "Failed to clone from template: #{@course_template.course}"
    end

    respond_with @course, location: [:teacher, @course]
  end

  private

    def course_params
      params.require(:course).permit(:title)
    end

    def course_template_id
      params.require(:course_template_id)
    end

    def set_course_template
      @course_template ||= Course.is_template.find(course_template_id)
    end
end
