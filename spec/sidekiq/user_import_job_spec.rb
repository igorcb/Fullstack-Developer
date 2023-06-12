require "rails_helper"
require "sidekiq/testing"

RSpec.describe UserImportJob, type: :job do
  describe "#perform" do
    subject { described_class.new }

    let(:file_path) { Rails.root.join("spec/fixtures/files/user_import.xlsx") }
    let(:upload) { create(:upload) }

    it "calls UserImportService" do
      user_import_service = instance_double(UserImportService)
      expect(UserImportService).to receive(:new).with(file_path, upload.id).and_return(user_import_service)
      expect(user_import_service).to receive(:call)

      Sidekiq::Testing.inline! do
        subject.perform(file_path, upload.id)
      end
    end
  end
end
