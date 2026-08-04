# frozen_string_literal: true

class Student::EnrollmentsController < StudentsController
  def new
    set_message

    @message = params[:message]
    @signup = Course::Signup.new
    @enrollment = Enrollment.new

    authorize @signup
  end

  def create
    @signup = Course::Signup.new(signup_params)

    authorize @signup

    @signup.email = current_user.email

    if @signup.save
      flash[:notice] = "You have enrolled in #{@signup.course_title}"
    else
      flash[:error] = "Enrollment failed"
    end

    respond_with @signup.enrollment, location: %i[student courses]
  end

  private

    def set_message
      @message ||= params.permit(:message)[:message]
    end

    def signup_params
      permitted_attributes(Course::Signup.new)
    end
end
