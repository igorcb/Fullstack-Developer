require "roo"

class UserImportService
  def initialize(file_path, upload_id)
    @file_path = file_path
    @upload_id = upload_id
  end

  def call
    spreadsheet = Roo::Spreadsheet.open(@file_path)
    header = spreadsheet.row(1)
    lines = spreadsheet.last_row - 1
    secure = SecureRandom.hex
    password = { password: secure, password_confirmation: secure }
    (2..lines).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      row.reverse_merge!(password)
      User.create!(row)
    end

    Upload.where(id: @upload_id).update(status: :completed, total_lines: spreadsheet.last_row)
  rescue StandardError => e
    Upload.where(id: @upload_id).update(status: :failed, error_messages: e.message)
  end
end
