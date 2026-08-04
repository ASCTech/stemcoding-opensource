class Student::ProgrammingLabs::Submissions::SubmissionFilesController < StudentsController
  skip_before_action :verify_authenticity_token

  def show
    set_submission_file

    authorize @file

    send_file(@file.file.path,
      filename: @file[:file],
      type: @file.file.content_type,
      disposition: :attachment)
  end

  private

    def submission_file_id
      params.require(:id)
    end

    def set_submission_file
      @file = SubmissionFile.find(submission_file_id)
    end
end
