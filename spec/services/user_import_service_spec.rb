require "rails_helper"

RSpec.describe UserImportService, type: :service do
  subject { described_class.new(file, upload.id) }

  let(:file_path) { Rails.root.join("spec/fixtures/files/user_import.xlsx") }

  let(:file) { file_path }
  let(:spreadsheet) { instance_double("spreadsheet") }
  let(:header) { %w[name email] }

  before do
    allow(Roo::Spreadsheet).to receive(:open).with(file_path).and_return(spreadsheet)
    allow(spreadsheet).to receive(:row).with(1).and_return(header)
  end

  describe "#import_users" do
    context "not create" do
      let(:upload) { create(:upload, file_name: "MyString Failed", status: :failed) }

      it "returns error" do
        allow(spreadsheet).to receive(:last_row).and_return(3)
        allow(spreadsheet).to receive(:row).with(2).and_return(["John Doe", "john@example.com"])
        allow(spreadsheet).to receive(:row).with(3).and_return(["Jane Smith", "jane@example.com"])

        allow(User).to receive(:create!).and_raise(StandardError.new("Full name can't be blank"))

        upload_update = instance_double(Upload)
        expect(Upload).to receive(:find).with(upload.id).and_return(upload_update)
        expect(upload_update).to receive(:update).with(status: :failed, error_messages: "Full name can't be blank")

        subject.call
      end
    end

    context "create" do
      let(:upload) { create(:upload) }

      it "creates users from spreadsheet data" do
        allow(spreadsheet).to receive(:last_row).and_return(3)
        expect(spreadsheet).to receive(:row).with(2).and_return(["John Doe", "john.doe@example.com"])
        expect(spreadsheet).to receive(:row).with(3).and_return(["Jane Smith", "jane.smith@example.com"])

        expect(User).to receive(:create!).with({ "name" => "John Doe", "email" => "john.doe@example.com", :password => "123456", :password_confirmation => "123456" })
        expect(User).to receive(:create!).with({ "name" => "Jane Smith", "email" => "jane.smith@example.com", :password => "123456", :password_confirmation => "123456" })

        upload_update = instance_double(Upload)
        expect(Upload).to receive(:find).with(upload.id).and_return(upload_update)
        expect(upload_update).to receive(:update).with(status: :completed, total_lines: 3)

        subject.call
      end
    end
  end
end
