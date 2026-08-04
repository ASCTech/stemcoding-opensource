# frozen_string_literal: true

# This controller allows a student to submit code from the IDE.
class Student::CourseProgrammingLabs::SubmissionFromIdesController < StudentsController
  def new
    set_course_lab
    @submission = @course_lab.submissions.new
    authorize @submission

    @query = params[:query]
  end

  def create
    set_course_lab

    @enrollment = current_user.enrollments.find_by!(course: @course_lab.course)

    @submission = Submission.new(submission_params)
    @submission.author = @enrollment
    @submission.course_programming_lab = @course_lab

    authorize @submission

    if params[:query].present?
      result = verifier.verify(params[:query])
      render_files = RenderFile.where(id: result[:ids], user: @enrollment.student)
    end

    @submission.build_from_render_files(render_files)

    if @submission.save
      flash[:notice] = "Submission for lab, #{@submission.lab_title}, successfully created."
    else
      flash[:error] = "Submission for lab, #{@submission.lab_title}, not created."
    end

    respond_with @submission, location: student_course_programming_lab_submissions_path(@course_lab)
  end

  private

    def set_course_lab
      @course_lab ||= CourseProgrammingLab.find(params.require(:course_programming_lab_id))
    end

    def submission_params
      params.require(:submission).permit(:student_comment)
    end
end
