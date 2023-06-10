require "roo"

class ImportUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user_admin

  def new; end

  def create
    if params[:file].present?
      temp_file = create_temp_file
      upload = Upload.create(file_name: params[:file].original_filename, status: :processing)
      UserImportJob.perform_async(temp_file.path, upload.id)
      flash[:notice] = "Importing users started in the background."
    else
      flash[:alert] = "No files have been selected."
    end

    redirect_to dashboard_path
  end

  private

  def create_temp_file
    file_name = "#{params[:file].original_filename}_#{Time.zone.now}"
    temp_file = Tempfile.new([file_name, ".xlsx"])
    temp_file.binmode
    temp_file.write(params[:file].read)
    temp_file.rewind
    temp_file
  end

  def import_params
    params.require(:import).permit(:file)
  end

  def authenticate_user_admin
    return if current_user.role?

    redirect_to profile_path,
                flash: { alert: "User does not have access to the [page]" }
  end
end
