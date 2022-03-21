require "rails_helper"

RSpec.describe Api::UsersController, type: :controller do
  describe "User manage" do
    let(:user) {create :user}
    it "#Create user" do
      post :create, params: {name: "Boat", email: "boatqi@gmail.com", format: :json}
      expect(response.status).to eq(200)
    end

    it "#User detail" do
      get :show, params: { id: user.id, format: :json}
      expect(response.status).to eq(200)
    end
  end
end