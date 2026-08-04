# frozen_string_literal: true

class Teacher::CourseTemplatesController < TeachersController
  skip_after_action :verify_policy_scoped, only: :index

  def index
    @templates =
      Teacher::CourseTemplatePolicy::Scope.new(current_user, Course)
        .resolve
        .page(params[:template_page])
        .per(40)
        .order_by_title

    authorize Course.new
  end

  def show
    set_course_template

    authorize @course_template

    @course_template.decorate
  end

  private

    def course_template_id
      params.require(:id)
    end

    def set_course_template
      @course_template ||= Course.is_template.find(course_template_id)
    end
end
