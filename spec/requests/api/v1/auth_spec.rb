require 'rails_helper'

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /auth/signin" do
    let!(:user) { create(:user, email: 'john@example.com', password: 'sekret')}
    
    it "authenticates and return a token" do
      post "/api/v1/auth/signin", params: {auth: { email: user.email, password: 'sekret' }}

      expect(response).to have_http_status(:accepted)
      expect(json['id']).to eq("#{User.last.id}")
      expect(json['type']).to eq('user')
      expect(json['attributes']['email']).to eq('john@example.com')
      expect(json['attributes']['token']).to eq(AuthTokenService.call(user.id))
    end

    it "returns error when email does not exist" do
      post "/api/v1/auth/signin", params: {auth: { email: 'noemail@host.com', password: 'sekret' }}

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq({
        'error': "Email doesn not exist"
      }.to_json)
    end

    it "returns error when password does not match" do
      post "/api/v1/auth/signin", params: {auth: { email: user.email, password: 'wrong' }}

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq({
        'error': "Incorrect password"
      }.to_json)
    end
  end
end
