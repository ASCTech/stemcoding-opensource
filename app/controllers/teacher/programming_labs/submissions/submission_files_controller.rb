class Teacher::ProgrammingLabs::Submissions::SubmissionFilesController < TeachersController
  def show
    @file = SubmissionFile.find(params[:id])
    authorize @file

    send_file(@file.file.path,
      filename: @file[:file],
      type: @file.file.content_type,
      disposition: :attachment)
  end
end
