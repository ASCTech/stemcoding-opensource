# frozen_string_literal: true

class Admin::DashboardsController < AdminsController
  def show
    authorize :dashboard, :show?

    @programming_labs = ProgrammingLab.order(:title).page(params[:programming_lab_page]).per(20)
    @users = User.order(:first_name).page(params[:user_page]).per(87)
    @courses = Course.order(:title).page(params[:course_page]).per(20)
  end
end
