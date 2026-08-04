class Teacher::ProgrammingLabsController < TeachersController
  include ProgrammingLabsPrefix

  def show
    find_programming_lab

    @programming_lab = @programming_lab.decorate
    authorize @programming_lab
  end

  private

    def lab_id
      params.require(:id)
    end

    def find_programming_lab
      @programming_lab ||= ProgrammingLab.includes(file_groups: :files)
        .find(lab_id)
    end
end
