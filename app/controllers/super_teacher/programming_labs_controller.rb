class SuperTeacher::ProgrammingLabsController < SuperTeachersController
  def new
    @programming_lab = ProgrammingLab.new(creator: current_user)

    authorize @programming_lab
  end

  def create
    @programming_lab = ProgrammingLab.new(lab_params)
    authorize @programming_lab

    @programming_lab.creator = current_user

    if @programming_lab.save
      flash[:notice] = "You have successfully created programming lab: #{@programming_lab.title}."
    else
      flash[:error] = "Error when creating programming lab."
    end

    respond_with @programming_lab, location: %i[teacher course_programming_labs]
  end

  def edit
    set_programming_lab
    authorize @programming_lab
  end

  def update
    set_programming_lab
    authorize @programming_lab

    if @programming_lab.update(lab_params)
      flash[:notice] = "You have successfully updated programming lab: #{@programming_lab.title}."
    else
      flash[:error] = "Error when updating programming lab."
    end

    respond_with @programming_lab, location: %i[teacher course_programming_labs]
  end

  # look in app/vies/programming_labs for partials
  def self._prefixes
    super | %w[programming_labs]
  end

  private

    def programming_lab_id
      params.require(:id)
    end

    def set_programming_lab
      @programming_lab ||= ProgrammingLab.find(programming_lab_id)
    end

    def lab_params
      permitted_attributes(ProgrammingLab.new)
    end
end
