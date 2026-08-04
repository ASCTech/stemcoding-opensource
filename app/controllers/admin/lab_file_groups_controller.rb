# frozen_string_literal: true

class Admin::LabFileGroupsController < AdminsController
  def show
    set_lab_file_group

    authorize @lab_file_group
  end

  private

    def lab_file_group_id
      params.require(:id)
    end

    def set_lab_file_group
      @lab_file_group ||= LabFileGroup.includes(:files).find(lab_file_group_id)
    end
end
