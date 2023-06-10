class UserImportJob
  include Sidekiq::Job

  def perform(file_path, upload_id)
    UserImportService.new(file_path, upload_id).call
  end
end
