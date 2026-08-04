class Teacher::ProgrammingLabs::CourseAssignmentsController < TeachersController
  def new
    find_programming_lab

    @courses = policy_scope(Course).reorder_by_title

    @course_assignment = CourseAssignment.new(programming_lab: @programming_lab)

    authorize(@course_assignment)
  end

  def create
    find_programming_lab
    @courses = Course.where(id: course_assignment_params.fetch("courses"))
    @course_assignment = CourseAssignment.new(programming_lab: @programming_lab, courses: @courses)

    authorize(@course_assignment)

    if @course_assignment.save
      flash[:notice] = "Courses assigned #{@programming_lab.title}"
    else
      flash[:error] = "Courses not assigned to #{@programming_lab.title}"
    end

    respond_with @course_assignment, location: teacher_course_programming_labs_path
  end

  private

    def lab_id
      params.fetch(:programming_lab_id)
    end

    def find_programming_lab
      @programming_lab ||= ProgrammingLab.find(lab_id)
    end

    def course_assignment_params
      permitted_attributes(CourseAssignment.new)
    end
end
