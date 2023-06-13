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
      login_admin
      let(:params) { ActionController::Parameters.new(import: { file: "test_file.xlsx" }) }
      let(:user) { create(:user, role: :admin) }
      let(:file_path) { Rails.root.join("tmp/uploads/test_file.xlsx") }
      let(:uploaded_file) { instance_double(ActionDispatch::Http::UploadedFile) }

      before do
        sign_in(user)
        allow(File).to receive(:open).and_call_original
        allow(uploaded_file).to receive(:read).and_return("test content")
      end

      it "with params valid" do
        file = fixture_file_upload("test_file.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        allow(Rails).to receive(:root).and_return(Pathname.new(""))
        allow(file).to receive(:original_filename).and_return("test_file.xlsx")
        allow(UserImportJob).to receive(:perform_async)

        post :create, params: { file: file }

        expect(File).to have_received(:open).with(file_path, "wb")
        expect(UserImportJob).to have_received(:perform_async).with(file_path, an_instance_of(Integer))
        expect(flash[:notice]).to eq("Importing users started in the background.")
        expect(response).to redirect_to(dashboard_path)
      end

      it "with params invalid" do
        post :create, params: { file: nil }

        expect(flash[:alert]).to eq("No files have been selected.")
        expect(response).to redirect_to(dashboard_path)
      end

      it "permits the file parameter" do
        controller.params = params

        expect(controller.send(:import_params)).to eq(params.require(:import).permit(:file))
      end
    end
  end
end
