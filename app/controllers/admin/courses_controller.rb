# frozen_string_literal: true

# This controller allows admins to create, edit, and view courses.
class Admin::CoursesController < AdminsController
  def edit
    set_course

    authorize @course

    @programming_labs = ProgrammingLab.pluck(:title, :id)
    @available_teachers = User.teachers
  end

  def index
    @courses = policy_scope(Course.is_not_template).order_by_title.page(params[:course_page]).per(20)
    @templates = policy_scope(Course.is_template).order_by_title.page(params[:template_course_page]).per(20)
    authorize Course
  end

  def new
    @course = Course.new
    authorize @course

    @programming_labs = ProgrammingLab.pluck(:title, :id)

    @available_teachers = User.teachers

    @course.gen_key_if_empty!
  end

  def create
    @course = Course.new(course_params)
    authorize @course

    @course.creator = current_user

    @programming_labs = ProgrammingLab.pluck(:title, :id)

    @available_teachers = User.teachers

    @course.gen_key_if_empty!

    if @course.save
      flash[:notice] = "You have successfully created course: #{@course.title}."
    else
      flash[:error] = "Course not successfully created."
    end

    respond_with @course, location: %i[admin courses]
  end

  def show
    @course = Course.includes(:programming_labs, :students).find(course_id).decorate
    authorize @course

    @programming_labs = @course.programming_labs.order_by_title.page(params[:programming_lab_page]).per(20)

    @students = @course.students.order_by_first_name.page(params[:user_page]).per(50)
  end

  def destroy
    set_course

    authorize @course

    if @course.destroy
      flash[:notice] = "You have successfully deleted course: #{@course.title}."
    else
      flash[:error] = "Course not successfully deleted."
    end

    respond_with @course, location: %i[admin courses]
  end

  def update
    set_course

    authorize @course

    if @course.update(course_params)
      flash[:notice] = "You have successfully updated course: #{@course.title}."
    else
      flash[:error] = "Course not successfully updated."
    end

    respond_with @course, location: %i[admin courses]
  end

  private

    def set_course
      @course ||= Course.find(course_id)
    end

    def course_id
      params.require(:id)
    end

    def course_params
      permitted_attributes(Course.new)
    end
end
