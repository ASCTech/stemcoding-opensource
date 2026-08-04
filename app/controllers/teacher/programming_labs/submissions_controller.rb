# frozen_string_literal: true

require "render_file_generator"

class Teacher::ProgrammingLabs::SubmissionsController < TeachersController
  def index
    # TODO: This is needs to be coded in if desired. Must be coded in by iter#2.
  end

  def show
    set_programming_lab
    set_submission

    authorize @submission

    @submission = @submission.decorate

    @previous_submissions = @submission.previous_submissions.reorder_by_created_at

    ide_internal(@submission.files)
  end

  def edit
    set_programming_lab
    set_submission

    authorize @submission

    @submission = @submission.decorate
  end

  def update
    set_submission
    authorize @submission

    if @submission.update(submission_params)
      flash[:notice] = "#{@submission.author_full_name}'s grade for #{@programming_lab.title} updated."
    else
      flash[:error] = "#{@submission.author_full_name}'s grade for #{@programming_lab.title} not updated."
    end

    respond_with @submission, location: [:teacher, @submission.programming_lab, @submission]
  end

  private

    def submission_params
      permitted_attributes(Submission.new)
    end

    def programming_lab_id
      params.require(:programming_lab_id)
    end

    def set_programming_lab
      @programming_lab ||= ProgrammingLab.find(programming_lab_id)
    end

    def submission_id
      params.require(:id)
    end

    def set_submission
      set_programming_lab

      @submission ||= @programming_lab.submissions.find(submission_id)
    end

  protected

    include IdesHelper

    def ide_submission(files)
      @tab_names = []
      @file_contents = []
      files.each do |file|
        @tab_names.push file[:file]
        @file_contents.push File.read(file.file.file.path)
      end
    end

    def gen_files
      @files = []
      @file_contents.each_with_index do |content, index|
        @files << {
          filename: @tab_names[index],
          content: content,
        }
      end
      @files_text = Base64.encode64(@files.to_json)
    end

    def ide_internal(files)
      ide_submission(files)
      gen_files
      @buttons_text = Base64.encode64([render_button].to_json)
    end
end
