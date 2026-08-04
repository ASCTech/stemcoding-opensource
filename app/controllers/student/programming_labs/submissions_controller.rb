# frozen_string_literal: true

# This controller allows the student to view and manipulate their submissions.
class Student::ProgrammingLabs::SubmissionsController < StudentsController
  def index
    set_programming_lab

    authorize @programming_lab.submissions.new

    @submissions = policy_scope(current_user.submissions.for_lab(@programming_lab))
  end

  def show
    set_programming_lab
    set_submission

    authorize @submission

    ids = @submission.files.ids
    use_norandom_p5 = @submission.programming_lab.use_norandom_p5
    message = { ids: ids, submission: true, use_norandom_p5: use_norandom_p5, lab_id: @programming_lab.id, expires: Time.zone.now + 1.day }
    @signed_message = verifier.generate(message)
  end

  def new
    set_programming_lab

    @submission = Submission.new(user: current_user)
    @submission.programming_lab = @programming_lab

    authorize @submission

    @previous_submissions = @submission.previous_submissions
      .with_instructor_comment
      .reorder_by_created_at

    use_norandom_p5 = @submission.programming_lab.use_norandom_p5
    message = { ids: [], new_files: true, use_norandom_p5: use_norandom_p5, lab_id: @programming_lab.id, expires: Time.zone.now + 1.day }
    @signed_message = verifier.generate(message)
  end

  def create
    set_programming_lab

    @submission = Submission.new(submission_params)

    @submission.user = current_user
    @submission.programming_lab = @programming_lab

    authorize @submission

    if @submission.save
      flash[:notice] = "Submission for programming lab, #{@programming_lab.title}, submitted."
    else
      flash[:error] = "Submission not created"
    end

    respond_with @submission, location: student_programming_lab_submissions_path
  end

  def destroy
  end

  private

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

    def submission_params
      permitted_attributes(Submission.new)
    end
end
