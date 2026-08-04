class Teacher::Courses::ProgrammingLabsController < TeachersController
  include ProgrammingLabsPrefix

  def show
    set_course
    set_lab

    authorize @lab

    @enrollments = @course.enrollments
    @lab = @lab.decorate
  end

  private

    def course_id
      params.require(:course_id)
    end

    def set_course
      @course ||= ::Course.includes(:enrollments).find(course_id)
    end

    def lab_id
      params.require(:id)
    end

    def set_lab
      set_course
      @lab ||= @course.programming_labs.includes(file_groups: :files).find(lab_id)
    end
end
