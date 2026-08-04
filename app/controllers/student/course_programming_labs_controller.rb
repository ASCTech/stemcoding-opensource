class Student::CourseProgrammingLabsController < StudentsController
  def show
    set_course_lab

    authorize(@course_lab)
  end

  private

    def course_lab_id
      params.require(:id)
    end

    def set_course_lab
      @course_lab ||= CourseProgrammingLab.find(course_lab_id)
    end
end
