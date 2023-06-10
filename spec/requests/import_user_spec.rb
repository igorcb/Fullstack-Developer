require 'rails_helper'

RSpec.describe "ImportUsers", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/import_user/create"
      expect(response).to have_http_status(:success)
    end
  end

end
