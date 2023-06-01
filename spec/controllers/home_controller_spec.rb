require "rails_helper"

RSpec.describe HomeController, type: :controller do
  context "when access GET '/' user not admin" do
    login_user

    it do
      get "index"

      expect(response).to redirect_to(profile_path)
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
