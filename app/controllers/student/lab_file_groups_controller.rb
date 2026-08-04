class Student::LabFileGroupsController < StudentsController
  def show
    set_lab_file_group

    authorize @lab_file_group

    ids = @lab_file_group.files.ids
    use_norandom_p5 = @lab_file_group.programming_lab.use_norandom_p5
    message = { ids: ids, use_norandom_p5: use_norandom_p5, lab_group: true, lab_id: @lab_file_group.lab_id, expires: Time.zone.now + 1.day }
    @signed_message = verifier.generate(message)
  end

  private

    def lab_file_group_id
      params.require(:id)
    end

    def set_lab_file_group
      @lab_file_group = LabFileGroup.includes(:files, :programming_lab)
        .find(lab_file_group_id)
    end
end
