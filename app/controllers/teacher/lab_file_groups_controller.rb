# frozen_string_literal: true

class Teacher::LabFileGroupsController < TeachersController
  def show
    @lab_file_group = LabFileGroup.includes(:files).find(params[:id])
    authorize @lab_file_group
  end
end
