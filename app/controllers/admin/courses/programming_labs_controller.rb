class Admin::Courses::ProgrammingLabsController < AdminsController
  include ProgrammingLabsPrefix

  def index
    set_course
    authorize ProgrammingLab.new

    @programming_labs = policy_scope(@course.programming_labs).order(:title)
      .page(page_param)
      .per(40)
  end

  def show
    set_course
    set_lab

    @lab = @lab.decorate
    authorize @lab
  end

  def new
    set_course

    @programming_lab = ProgrammingLab.new

    authorize(@programming_lab)
  end

  def create
    set_course

    @programming_lab = ProgrammingLab.new(lab_params)

    authorize(@programming_lab)

    @programming_lab.creator = current_user
    @programming_lab.courses << @course

    if @programming_lab.save
      flash[:notice] = "You have successfully created programming lab: #{@programming_lab.title}."
    else
      flash[:error] = "Error when creating programming lab."
    end

    respond_with @programming_lab, location: [:admin, @programming_lab]
  end

  def edit
    set_course
    set_lab

    authorize @lab
  end

  def update
    set_course
    set_lab

    authorize @lab

    if @lab.update(lab_params)
      flash[:notice] = "You have successfully updated programming lab: #{@lab.title}."
    else
      flash[:error] = "Error when updating programming lab."
    end

    respond_with @lab, location: [:admin, @course, @lab]
  end

  private

    def course_id
      params.require(:course_id)
    end

    def set_course
      @course ||= Course.find(course_id)
    end

    def lab_id
      params.require(:id)
    end

    def set_lab
      set_course
      @lab ||= @course.programming_labs.includes(file_groups: :files).find(lab_id)
    end

    def lab_params
      permitted_attributes(ProgrammingLab.new)
    end

    def page_param
      params.permit(:programming_lab_page)[:programming_lab_page]
    end
end
