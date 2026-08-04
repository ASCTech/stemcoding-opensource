# frozen_string_literal: true

#
# This controller gives the teacher access to their courses.
#
class Teacher::CoursesController < TeachersController
  def show
    set_course
    authorize @course

    @students = @course.students
      .order_by_first_name
      .page(params[:student_page]).per(50)

    @course_labs = @course.course_programming_labs.reorder_by_position
  end

  def new
    @course = Course.new

    authorize @course

    @available_teachers = User.teachers.where.not(id: current_user.id).order_by_first_name
  end

  def create
    @course = Course.new(course_params)
    authorize @course

    @course.creator = current_user
    @course.teachers << current_user

    @course.join_key = @course.gen_key if @course.join_key.empty?

    if @course.save
      flash[:notice] = "Course, #{@course.title}, has been created."
    else
      flash[:error] = "Course not created."
    end

    respond_with @course, location: [:teacher, @course]
  end

  def edit
    set_course
    authorize @course

    @available_teachers = User.teachers.order_by_first_name
  end

  def update
    set_course

    authorize @course

    if @course.update(course_params)
      flash[:notice] = "Successfully updated course, #{@course.title}."
    else
      flash[:error] = "Failed to create course."
    end

    respond_with @course, location: [:teacher, @course]
  end

  def destroy
    set_course

    authorize @course

    if @course.destroy
      flash[:notice] = "Course, #{course.title}, has been destroyed."
    else
      flash[:error] = "Course not destroyed."
    end

    respond_with @course, location: teacher_dashboard_path
  end

  private

    def course_id
      params.require(:id)
    end

    def set_course
      @course ||= ::Course.includes(course_programming_labs: :programming_lab).find(course_id)
    end

    def course_params
      permitted_attributes(::Course.new)
    end
end
