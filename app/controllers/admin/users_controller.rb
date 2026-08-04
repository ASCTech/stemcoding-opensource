# frozen_string_literal: true

# This allows an administrator to edit and control users.
class Admin::UsersController < AdminsController
  def edit
    set_user

    authorize @user
  end

  def update
    set_user

    authorize @user

    if @user.update(user_params)
      flash[:notice] = "User updated."
    else
      flash[:error] = "User not updated."
    end

    respond_with @user, location: admin_users_path
  end

  def show
    set_user

    authorize @user
  end

  def index
    @users = policy_scope(User.all).order(:first_name).page(params[:user_page]).per(100)

    authorize User.new
  end

  def destroy
    set_user

    authorize @user

    if @user.destroy
      flash[:notice] = "User destroyed."
    else
      flash[:error] = "User not destroyed."
    end

    respond_with @user, location: %i[admin users]
  end

  private

    def user_id
      params.require(:id)
    end

    def set_user
      @user ||= User.find(user_id)
    end

    def user_params
      permitted_attributes(User.new)
    end
end
