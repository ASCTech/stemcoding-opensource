# frozen_string_literal: true

class Admin::ProgrammingLabsController < AdminsController
  include ProgrammingLabsPrefix

  def new
    @programming_lab = ProgrammingLab.new
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

    respond_with @programming_lab, location: [:admin, @programming_lab]
  end

  def destroy
    find_programming_lab

    authorize @programming_lab

    if @programming_lab.destroy
      flash[:notice] = "You have successfully deleted programming lab: #{@programming_lab.title}."
    else
      flash[:error] = "Error when deleting programming lab."
    end

    respond_with @programming_lab, location: %i[admin programming_labs]
  end

  def edit
    find_programming_lab
    authorize @programming_lab
  end

  def update
    find_programming_lab
    authorize @programming_lab

    if @programming_lab.update(lab_params)
      flash[:notice] = "You have successfully updated programming lab: #{@programming_lab.title}."
    else
      flash[:error] = "Error when updating programming lab."
    end

    respond_with @programming_lab, location: [:admin, @programming_lab]
  end

  def index
    @programming_labs = policy_scope(ProgrammingLab).order(:title).page(page_param).per(40)
    authorize ProgrammingLab
  end

  def show
    find_programming_lab

    @programming_lab = @programming_lab.decorate
    authorize @programming_lab
  end

  private

    def page_param
      params.permit(:programming_lab_page)[:programming_lab_page]
    end

    def programming_lab_id
      params.require(:id)
    end

    def find_programming_lab
      @programming_lab ||= ProgrammingLab.includes(file_groups: :files)
        .find(programming_lab_id)
    end

    def lab_params
      permitted_attributes(ProgrammingLab.new)
    end
end
