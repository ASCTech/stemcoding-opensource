# frozen_string_literal: true

class Teacher::LabFileGroups::ProgrammingLabFilesController < TeachersController
  skip_before_action :verify_authenticity_token

  def show
    @file = ProgrammingLabFile.find(params[:id])
    authorize @file
    send_file(@file.file.path,
      filename: @file[:file],
      type: @file.file.content_type,
      disposition: :attachment)
  end
end
