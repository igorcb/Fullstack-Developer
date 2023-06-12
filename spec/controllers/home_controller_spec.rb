require "rails_helper"

RSpec.describe HomeController, type: :controller do
  context "when access GET '/' user not admin" do
    let(:user_not_admin) { create(:user) }

    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user_not_admin
    end

    it do
      get "index"

      expect(response).to redirect_to(user_path(user_not_admin))
    end
  end

  context "when access GET '/' user admin" do
    login_admin

    it do
      get "index"

      expect(response).to redirect_to(dashboard_path)
    end
  end

  describe "when access page 'dashboard' " do
    context "with user not admin" do
      login_user

      it do
        get "dashboard"

        expect(response).not_to be_successful
      end
    end

    context "with user admin" do
      login_admin

      it do
        get "dashboard"

        expect(response).to be_successful
      end
    end
  end
end
