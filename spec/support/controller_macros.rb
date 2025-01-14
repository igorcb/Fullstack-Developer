module ControllerMacros
  def login_user
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      sign_in user
    end
  end

  def login_admin
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      user = FactoryBot.create(:user, role: true)
      sign_in user
    end
  end
end
