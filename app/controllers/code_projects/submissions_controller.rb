# frozen_string_literal: true

class CodeProjects::SubmissionsController < ApplicationController
  def new
    set_code_project

    authorize @code_project

    @course_labs = current_user.enrolled_course_labs
      .submittable
      .includes(:course, :programming_lab)

    @submission = Submission.new
    # @submission.course_programming_lab_id = @code_project.course_programming_lab_id
  end

  def create
    set_code_project

    @submission = Submission.new(submission_params)

    # programming_lab = CourseProgrammingLab.find(submission_params['course_programming_lab_id'])

    @submission.author = @submission.enrollments.find_by(student: current_user)
    @submission.files = @code_project.submission_files

    if @submission.valid?
      authorize(@submission)
    else
      skip_authorization
    end

    if @submission.save
      flash[:notice] = "Code project submitted for programming lab, #{@submission.course_lab_title}"
      respond_with @submission, location: [:student, @submission.course_programming_lab, :submissions]
    else
      flash[:error] = "Code project not submitted for programming lab"

      # Reset instance variables
      @course_labs = current_user.enrolled_course_labs
        .submittable
        .includes(:course, :programming_lab)

      render :new, status: :unprocessable_entity
    end
  end

  private

    def submission_params
      permitted_attributes(Submission.new)
    end

    def query_param
      params.permit(:query)[:query]
    end

    def code_project_id
      params.require(:code_project_id)
    end

    def set_code_project
      @code_project ||= CodeProject.find(code_project_id)
    end
end
