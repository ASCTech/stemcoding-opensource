class Student::CourseProgrammingLabs::SubmissionsController < StudentsController
  def new
    set_course_lab
    set_enrollment

    @submission = @course_lab.submissions.new(author: @enrollment, programming_lab: @course_lab.programming_lab)

    authorize @submission

    @previous_submissions = @course_lab.submissions.authored_by(@enrollment)
      .with_instructor_comment
      .reorder_by_created_at

    use_norandom_p5 = @submission.programming_lab.use_norandom_p5

    message = { ids: [], new_files: true, use_norandom_p5: use_norandom_p5, course_programming_lab_id: course_lab_id, expires: Time.zone.now + 1.day }
    @signed_message = verifier.generate(message)
  end

  def create
    set_course_lab
    set_enrollment

    @submission = @course_lab.submissions.new(submission_params)
    @submission.author = @enrollment

    authorize(@submission)

    if @submission.save
      flash[:notice] = "Submission created for #{@course_lab.title}"
    else
      flash[:error] = "Submission not created for #{@course_lab.title}"
    end

    respond_with @submission, location: [:student, @course_lab, @submission]
  end

  def edit
    set_course_lab
    set_enrollment
    set_submission

    authorize @submission

    @previous_submissions = @course_lab.submissions.authored_by(@enrollment)
      .with_instructor_comment
      .reorder_by_created_at
  end

  def update
  end

  def index
    set_course_lab

    @submissions = policy_scope(@course_lab.submissions).order_by_created_at
    authorize(@course_lab.submissions.new)
  end

  def show
    set_course_lab
    set_submission

    authorize @submission

    submission_files = @submission.files.pluck(:id)
    new_files = submission_files.empty? ? true : false

    use_norandom_p5 = @submission.programming_lab.use_norandom_p5

    message = { ids: submission_files, new_files: new_files, use_norandom_p5: use_norandom_p5, submission: true, course_programming_lab_id: course_lab_id, expires: Time.zone.now + 1.day }
    @signed_message = verifier.generate(message)
  end

  private

    def submission_params
      permitted_attributes(Submission.new)
    end

    def course_lab_id
      params.require(:course_programming_lab_id)
    end

    def set_course_lab
      @course_lab ||= CourseProgrammingLab.joins(:course, :programming_lab)
        .find(course_lab_id)
    end

    def set_enrollment
      set_course_lab

      @enrollment ||= current_user.enrollments.enrolled_in(@course_lab.course).first
    end

    def submission_id
      params.require(:id)
    end

    def set_submission
      set_course_lab

      @submission ||= @course_lab.submissions.includes(:files).find(submission_id)
    end
end
