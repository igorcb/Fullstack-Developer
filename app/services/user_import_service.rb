require "roo"

class UserImportService
  def initialize(file_path, upload_id)
    @file_path = file_path
    @upload_id = upload_id
  end

  def call
    spreadsheet = Roo::Spreadsheet.open(@file_path)
    header = spreadsheet.row(1)
    lines = spreadsheet.last_row
    secure = "123456"
    password = { password: secure, password_confirmation: secure }
    (2..lines).each do |line|
      row = Hash[[header, spreadsheet.row(line)].transpose]
      row.reverse_merge!(password)
      User.create!(row)
    end

    find_update.update(status: :completed, total_lines: spreadsheet.last_row)
  rescue StandardError => e
    find_update.update(status: :failed, error_messages: e.message)
  end

  private

  def find_update
    @find_update ||= Upload.find(@upload_id)
  end
end
