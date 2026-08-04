# frozen_string_literal: true

class Student::DashboardsController < StudentsController
  def show
    authorize :dashboard, :show?

    @courses = policy_scope(::Course).includes(course_programming_labs: :programming_lab)
      .references(:course_programming_labs)
      .merge(::Course.reorder_by_created_at(:desc))
      .merge(CourseProgrammingLab.order_by_position)
  end
end
