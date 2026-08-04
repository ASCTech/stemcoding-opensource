# frozen_string_literal: true

class CodeProjectsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @code_projects = policy_scope(CodeProject).where.not(name: "converted from submission")
    authorize CodeProject

    courses = Student::CoursePolicy::Scope.new(current_user, Course).resolve

    @my_submissions = []
    courses.each do |course|
      course.course_labs.includes(:programming_lab).each do |course_lab|
        course_lab.submissions.includes(:author).select {|s| s.author.student_id == current_user.id}.each do |submission|
          @my_submissions << submission
        end
      end
    end
  end

  def show
    set_code_project

    authorize @code_project
    @code_project_files = @code_project.code_project_files

  end

  def new
      @code_project = CodeProject.new
      authorize @code_project

      # users can create code projects from the ide page if they choose to "Save
      # Project"
      if query_param
        @signed_message = query_param
        @result = verifier.verify(@signed_message)
        ids = @result[:ids]
        @files = RenderFile.where(id: ids, user: current_user)
        @file_names = @files.pluck(:name)

        if @result[:course_programming_lab_id] && !@result[:course_programming_lab_id].empty?
          @code_project.name = CourseProgrammingLab.find(@result[:course_programming_lab_id]).title
        end
      end
  end

  def create
    @code_project = CodeProject.new(code_project_params)
    @code_project.user = current_user

    authorize @code_project

    # setup the render files.
    if query_param
      @signed_message = query_param
      @result = verifier.verify(@signed_message)
      @code_project.course_programming_lab_id = @result[:course_programming_lab_id]
      ids = @result[:ids]
      @render_files = RenderFile.where(id: ids, user: current_user)
    end

    if @code_project.save
      @render_files.each do |render_file|
        code_file = CodeProjectFile.new(name: render_file.name, content: render_file.content)

        @code_project.code_project_files << code_file
      end

      flash[:notice] = "Code project, #{@code_project.name}, created."
    else
      flash[:error] = "Code project not created."
    end

    respond_with @code_project, location: code_projects_path
  end

  def destroy
    set_code_project

    authorize @code_project

    if @code_project.destroy
      flash[:notice] = "Code project, #{@code_project.name}, has been destroyed."
    else
      flash[:error] = "Code project not destroyed."
    end

    respond_with @code_project, location: code_projects_path
  end

  private

    def query_param
      params[:query] || params[:code_project][:query]
    end

    def code_project_params
      permitted_attributes(CodeProject.new)
    end

    def code_project_id
      params.require(:id)
    end

    def set_code_project
      @code_project ||= CodeProject.find(code_project_id)
    end

end
