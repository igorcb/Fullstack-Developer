require "rails_helper"
require "tempfile"

RSpec.describe ImportUsersController, type: :controller do
  describe "GET #new" do
    context "user not admin" do
      login_user
      it do
        get :new

        expect(response).to redirect_to(profile_path)
      end
    end

    context "user admin" do
      login_admin
      it do
        get :new

        expect(response).to be_successful
      end
    end
  end

  describe "POST #create" do
    context "user not admin" do
      login_user
      it do
        post :create

        expect(response).to redirect_to(profile_path)
      end
    end

    context "user admin" do
      let(:params) { ActionController::Parameters.new(import: { file: Rails.root.join("spec/fixtures/files/user_import.xlsx") }) }
      let(:file_path) { Rails.root.join("spec/fixtures/files/user_import.xlsx") }
      let(:file) { fixture_file_upload(file_path, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") }
      let(:temp_file) { instance_double(Tempfile) }
      let(:upload) { instance_double(Upload) }

      login_admin
      it "with params invalid" do
        post :create, params: { import: { file: "" } }

        expect(response).not_to be_successful
      end

      it "with params valid" do
        allow(Tempfile).to receive(:new).and_wrap_original do |original_method, *args|
          temp_file = original_method.call(*args)
          allow(temp_file).to receive(:path).and_return(file_path)
          temp_file
        end

        expect(Upload).to receive(:create).with(file_name: "user_import.xlsx", status: :processing).and_return(upload = instance_double(Upload))
        expect(upload).to receive(:id).and_return(1)

        expect(UserImportJob).to receive(:perform_async).with(file_path, 1)

        post :create, params: { file: file }

        expect(flash[:notice]).to eq("Importing users started in the background.")
        expect(response).to redirect_to(dashboard_path)
      end

      it "permits the file parameter" do
        controller.params = params

        expect(controller.send(:import_params)).to eq(params.require(:import).permit(:file))
      end
    end
  end
end
