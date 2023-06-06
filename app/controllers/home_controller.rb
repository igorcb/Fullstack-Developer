class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]
  before_action :authenticate_user_admin, only: %i[dashboard]

  def index
    return render "index" unless current_user

    if current_user.role?
      redirect_to dashboard_path
    else
      redirect_to profile_path
    end
  end

  def dashboard
    @users = User.all
    @users_admin = User.admin
    @users_not_admin = User.not_admin
  end

  def profile; end

  private

  def authenticate_user_admin
    return if current_user.role?

    redirect_to profile_path,
                flash: { alert: "User does not have access to the [dashboard]" }
  end
end
