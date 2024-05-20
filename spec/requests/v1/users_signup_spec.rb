require 'rails_helper'

RSpec.describe "V1::Users", type: :request do
  describe "POST /users/signup" do
    context "with valid params" do
      it "registers a new user" do
        post "/v1/users/signup", params: 
          { firstName: 'John', lastName: 'Doe', email: 'john.doe@example.com', password: 'sekret' }

        expect(response).to have_http_status(:created)
        expect(json['id']).to eq("#{User.last.id}")
        expect(json['type']).to eq('user')
        expect(json['attributes']['email']).to eq('john.doe@example.com')
        expect(json['attributes']['token']).to eq(AuthTokenService.call(User.last.id))
      end
    end
    context "with invalid params" do
      it "throws an error" do
        post "/v1/users/signup", params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Email can't be blank")
        expect(response.body).to include("Password can't be blank")
      end
    end
  end
end