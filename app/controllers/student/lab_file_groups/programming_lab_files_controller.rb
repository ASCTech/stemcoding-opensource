class Student::LabFileGroups::ProgrammingLabFilesController < StudentsController
  # see:
  # https://api.rubyonrails.org/v5.2/classes/ActionController/RequestForgeryProtection.html
  skip_before_action :verify_authenticity_token

  def show
    set_lab_file

    authorize @file

    send_data(@file.file.path,
      filename: @file[:file],
      type: @file.file.content_type)
  end

  private

    def lab_file_id
      params.require(:id)
    end

    def set_lab_file
      @file = ProgrammingLabFile.find(lab_file_id)
    end
end
