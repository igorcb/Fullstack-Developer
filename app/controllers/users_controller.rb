class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user_admin
  before_action :set_user, only: %i[show edit update destroy toggle_admin]

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to dashboard_path, notice: "User was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        if current_user.role?
          format.html { redirect_to dashboard_path, notice: "User was successfully updated." }
        else
          format.html { redirect_to user_path(@user), notice: "User was successfully updated." }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_path, notice: "User was successfully destroyed." }
    end
  end

  def toggle_admin
    @user.toggle!(:role)
    redirect_to dashboard_path, notice: "Admin status was successfully updated."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:full_name, :email, :role, :avatar, :password, :password_confirmation)
  end

  def authenticate_user_admin
    id = (params[:id].presence || -1)
    @user ||= User.where(id: id).first

    return if @user.present? && @user.id == current_user.id

    return if current_user.role?

    redirect_to profile_path,
                flash: { alert: "User does not have access to the page" }
  end
end
