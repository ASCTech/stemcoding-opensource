class Teacher::CourseProgrammingLabsController < TeachersController
  include ProgrammingLabsPrefix

  def index
    authorize(CourseProgrammingLab.new)

    @courses =
      policy_scope(::Course)
        .includes(course_programming_labs: :programming_lab)
        .references(:course_programming_labs)
        .reorder_by_created_at
        .merge(::CourseProgrammingLab.order_by_position)
        .with_at_least_one_lab

    @programming_labs = policy_scope(::ProgrammingLab)
      .includes(course_programming_labs: :course)
      .references(:course_programming_labs, :courses)
      .reorder_by_title
  end

  def show
    set_course_lab

    @course = @course_lab.course
    @lab = @course_lab.programming_lab

    authorize @course
    authorize @lab

    @enrollments = @course_lab.enrollments.includes(:student, :course)
    @lab = @lab.decorate
  end

  def update
    set_course_lab

    authorize @course_lab

    @course_lab.update(course_lab_params)

    if @course_lab.submittable_previously_changed?
      CourseLabMailer.with(course_lab: @course_lab).notify_students_of_status.deliver_later
    end
  end

  private

    def course_lab_id
      params.require(:id)
    end

    def set_course_lab
      @course_lab = CourseProgrammingLab.includes(:course, :programming_lab).find(course_lab_id)
    end

    def course_lab_params
      permitted_attributes(CourseProgrammingLab.new)
    end
end
