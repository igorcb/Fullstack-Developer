require "rails_helper"

RSpec.describe UsersController, type: :controller do
  subject(:user) { create(:user) }

  let(:user_params) {
    {
      full_name: "John Doe",
      email: Faker::Internet.email,
      role: false,
    }
  }

  let(:user_full_params) {
    {
      full_name: "John Doe",
      email: Faker::Internet.email,
      role: false,
      password: "password",
      password_confirmation: "password",
    }
  }

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

  describe "GET #edit" do
    context "user not admin" do
      login_user
      it do
        get :edit, params: { id: user.id }

        expect(response).to redirect_to(profile_path)
      end
    end

    context "user admin" do
      login_admin
      it do
        get :edit, params: { id: user.id }

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
      it "with params invalid" do
        post :create, params: { user: { full_name: "", email: "" } }

        expect(response).not_to be_successful
      end

      it "with params valid" do
        post :create, params: { user: user_full_params }

        user_last = User.last
        expect(user_last.full_name).to eq(user_full_params[:full_name])
        expect(user_last.email).to eq(user_full_params[:email])
        expect(user_last.role).to eq(user_full_params[:role])
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "PUT #update" do
    context "user not admin" do
      login_user
      it do
        put :update, params: { id: user.id, user: { full_name: "", email: "" } }

        expect(response).to redirect_to(profile_path)
      end
    end

    context "user admin" do
      login_admin
      it "with params invalid" do
        put :update, params: { id: user.id, user: { full_name: "", email: "" } }

        expect(response).not_to be_successful
      end

      it "with params valid" do
        full_name = Faker::Name.name
        put :update, params: { id: user.id, user: { full_name: full_name } }

        user_last = User.where(id: user.id).first
        expect(user_last.full_name).to eq(full_name)
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "user is not admin but he is the owner of the profile" do
      let(:user_not_admin) { create(:user) }

      before do
        request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user_not_admin
      end

      it "updates the information" do
        full_name = Faker::Name.name
        put :update, params: { id: user_not_admin.id, user: { full_name: full_name } }

        user_last = User.where(id: user_not_admin.id).first
        expect(user_last.full_name).to eq(full_name)
        expect(response).to redirect_to(user_path(user_not_admin))
      end
    end
  end

  describe "DELETE #destroy" do
    context "user not admin" do
      login_user
      it do
        delete :destroy, params: { id: user.id }

        expect(response).to redirect_to(profile_path)
      end
    end

    context "user admin" do
      login_admin
      let!(:user_destroy) { create(:user) }

      it do
        expect { delete :destroy, params: { id: user_destroy.id } }.to change { User.count }.by(-1)

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "GET #toggle" do
    context "user not admin" do
      login_user
      it do
        get :toggle_admin, params: { id: user.id }

        expect(response).to redirect_to(profile_path)
      end
    end

    context "user admin" do
      login_admin

      let(:user_toggle) { create(:user, role: false) }

      it do
        get :toggle_admin, params: { id: user_toggle.id }

        user_toggle.reload
        expect(user_toggle.role).to eq(true)
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
