require "rails_helper"

RSpec.describe RegistrationsController, type: :controller do
  let(:user_params) {
    {
      full_name: "John Doe",
      email: Faker::Internet.email,
      role: false,
      password: "password",
      password_confirmation: "password",
    }
  }

  describe "POST #create" do
    login_user

    it "user attributes" do
      post :create, params: { user: user_params }

      subject.current_user.reload
      expect(response).to have_http_status :found
    end
  end
end
