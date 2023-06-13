require "roo"

class ImportUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user_admin

  def new; end

  def create
    if params[:file].present?
      FileUtils.mkdir_p("tmp/uploads")

      file = params[:file]
      file_path = Rails.root.join("tmp", "uploads", file.original_filename)

      File.open(file_path, "wb") do |f|
        f.write(file.read)
      end

      upload = Upload.create(file_name: file.original_filename, status: :processing)
      UserImportJob.perform_async(file_path, upload.id)
      flash[:notice] = "Importing users started in the background."
    else
      flash[:alert] = "No files have been selected."
    end

    redirect_to dashboard_path
  end

  private

  def import_params
    params.require(:import).permit(:file)
  end

  def authenticate_user_admin
    return if current_user.role?

    redirect_to profile_path,
                flash: { alert: "User does not have access to the [page]" }
  end
end
