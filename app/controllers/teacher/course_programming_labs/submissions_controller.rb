class Teacher::CourseProgrammingLabs::SubmissionsController < TeachersController
  def show
    set_submission

    authorize(@submission)

    @submission = @submission.decorate
    @previous_submissions = @submission.previous_submissions.reorder_by_created_at(:desc)

    ide_internal(@submission.files)
  end

  def edit
    set_submission

    authorize(@submission)

    @submission = @submission.decorate
    @previous_submissions = @submission.previous_submissions.reorder_by_created_at(:desc)

    ide_internal(@submission.files)
  end

  def update
    set_submission
    authorize @submission

    if @submission.update(submission_params)
      flash[:notice] = "#{@submission.author_full_name}'s grade for #{@course_lab.lab_title} updated."

      mailer = SubmissionMailer.with(submission: @submission)

      if @submission.grade_previously_changed?
        mailer.notify_author_of_grade.deliver_later
      elsif @submission.instructor_comment_previously_changed?
        mailer.notify_author_of_instructor_comment.deliver_later
      end
    else
      flash[:error] = "#{@submission.author_full_name}'s grade for #{@course_lab.lab_title} not updated."
    end

    respond_with @submission, location: [:teacher, @course_lab.course, :gradebook]
  end

  private

    def submission_params
      permitted_attributes(Submission.new)
    end

    def course_lab_id
      params.require(:course_programming_lab_id)
    end

    def submission_id
      params.require(:id)
    end

    def set_course_lab
      @course_lab ||= CourseProgrammingLab.includes(:submissions).find(course_lab_id)
    end

    def set_submission
      set_course_lab

      @submission ||= @course_lab.submissions.find(submission_id)
    end

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
