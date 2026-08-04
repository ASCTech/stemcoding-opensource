# frozen_string_literal: true

# This controller serves to give access to the homepage.
class PagesController < ApplicationController
  skip_after_action :verify_authorized

  def home
    if current_user.admin?
      redirect_to admin_dashboard_path
    elsif current_user.super_teacher? || current_user.teacher?
      redirect_to teacher_dashboard_path
    elsif current_user.student?
      redirect_to student_dashboard_path
    end
  end
end
