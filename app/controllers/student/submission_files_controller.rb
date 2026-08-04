class Student::SubmissionFilesController < StudentsController
  skip_before_action :verify_authenticity_token

  def show
    file_id = params.require(:id)
    @submission_file = SubmissionFile.find(file_id)

    authorize @submission_file

    send_file(@submission_file.file.path,
      filename: @submission_file[:file],
      type: @submission_file.file.content_type,
      disposition: :attachment)
  end
end
