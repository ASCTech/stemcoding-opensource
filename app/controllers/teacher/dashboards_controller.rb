# frozen_string_literal: true

class Teacher::DashboardsController < TeachersController
  def show
    authorize :dashboard, :show?

    @courses =
      policy_scope(::Course)
        .left_joins(:course_programming_labs)
        .reorder_by_created_at(:desc)
        .merge(::CourseProgrammingLab.order_by_position)
  end

  private

    def course_page
      params.permit(:course_page)[:course_page]
    end
end
