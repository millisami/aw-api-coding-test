require 'rails_helper'

RSpec.describe "V1::Contents", type: :request do
  let!(:user) { create(:user) }
  let!(:contents) { create_list(:content, 5, user: user) }
  let(:content_id) { contents.last.id }

  describe "GET /content" do
    context 'with valid auth token' do
      before { get '/v1/content', headers: {'Authorization' => AuthTokenService.call(user.id)} }
      
      it "returns contents" do
        expect(json).not_to be_empty
        expect(json.size).to eq(5)
      end

      it "returns 200 status code" do
        expect(response).to have_http_status(200)
      end
    end

    context 'without auth token' do
      before { get '/v1/content' }

      it "returns unauthorized 401 status code" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /contents/:id" do
    context 'with valid auth token' do
      before { get "/v1/contents/#{content_id}", headers: {'Authorization' => AuthTokenService.call(user.id)} }

      context "when content exists" do
        it "returns 200 status code" do
          expect(response).to have_http_status(200)
        end

        it "returns the content" do
          # TODO: Nedd to find a way to convert the id to numeric instead of string
          expect(json['id']).to eq("#{content_id}")
        end
      end

      context "when content does not exist" do
        let(:content_id) { 0 }

        it "returns 404 status code" do
          expect(response).to have_http_status(404)
        end

        it "returns an error message" do
          expect(response.body).to include("Couldn't find Content with 'id'=0")
        end
      end
    end

    context 'without auth token' do
      before { get "/v1/contents/#{content_id}" }

      it "returns unauthorized 401 status code" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /contents" do
    # Valid payload
    let(:valid_payload) do
      { 
        title: 'Along the way of Tshorolpa',
        body: 'The staircases along the way was like way to heaven'
      }
    end

    context "with valid auth token" do
      context "with valid request attributes" do
        before { post '/v1/contents', params: valid_payload, headers: {'Authorization' => AuthTokenService.call(user.id)} }
        
        it "returns 201 status code" do
          expect(response).to have_http_status(201)
        end
      end

      context "with invalid request attributes" do
        before { post '/v1/contents', params: {}, headers: {'Authorization' => AuthTokenService.call(user.id)} }

        it "returns 422 status code" do
          expect(response).to have_http_status(422)
        end

        it "returns a failure message" do
          expect(response.body).to include("can't be blank")
        end
      end
    end

    context 'without auth token' do
      before { post '/v1/contents', params: valid_payload, headers: {'Authorization' => ''} }

      it "returns unauthorized 401 status code" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end

  describe "PUT /contents/:id" do
    let(:valid_payload) { { title: 'Changed Across Langtang', body: 'Changed the body' } }
    let!(:other_content) { create(:content) }

    context "with valid auth token" do
      context "should be able to update if the content belongs to the user" do
        before { put "/v1/contents/#{content_id}", params: valid_payload, headers: {'Authorization' => AuthTokenService.call(user.id)} }

        context "when the content exists" do
          it "returns 200 status code" do
            expect(response).to have_http_status(200)
          end
          it "updates the content title and body" do
            expect(json['attributes']['title']).to eq('Changed Across Langtang')
            expect(json['attributes']['body']).to eq('Changed the body')
          end
        end

        context "when the content does not exist" do
          let(:content_id) { 0 }
          it "returns 404 status code" do
            expect(response).to have_http_status(404)
          end

          it "returns an error message" do
            expect(response.body).to include("Couldn't find Content with 'id'=0")
          end
        end
      end

      context "should not be able to update if it belongs to other user" do
        before { put "/v1/contents/#{other_content.id}", params: valid_payload, headers: {'Authorization' => AuthTokenService.call(user.id)} }

        context "even if the content exist" do
          it "returns 404 status code" do
            expect(response).to have_http_status(404)
          end

          it "returns an error message" do
            expect(response.body).to include("Couldn't find Content with 'id'=#{other_content.id}")
          end
        end
      end
    end
  end

  describe "DELETE /v1/contents/:id" do
    let!(:other_content) { create(:content) }

    context "with valid auth token" do
      context "should be able to delete only if the content belongs to the user" do
        before { delete "/v1/contents/#{content_id}", headers: {'Authorization' => AuthTokenService.call(user.id)} }

        context "when the content exists" do
          it "returns 200 status code with message" do
            expect(response).to have_http_status(200)
            expect(response.body).to include("Deleted")
          end
        end

        context "when the content does not exist" do
          let(:content_id) { 0 }
          it "returns 404 status code" do
            expect(response).to have_http_status(404)
          end
        end
      end

      context "should not be able to delete if it belongs to other user" do
        before { delete "/v1/contents/#{other_content.id}", headers: {'Authorization' => AuthTokenService.call(user.id)} }

        context "even if the content exist" do
          it "returns 404 status code" do
            expect(response).to have_http_status(404)
          end

          it "returns an error message" do
            expect(response.body).to include("Couldn't find Content with 'id'=#{other_content.id}")
          end
        end
      end
    end
  end
end
