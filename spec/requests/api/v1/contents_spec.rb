require 'rails_helper'

RSpec.describe "Api::V1::Contents", type: :request do

  let!(:contents) { create_list(:content, 5) }
  let(:content_id) { contents.last.id }

  describe "GET /content" do
    # Fire up http GET request before each example
    before { get '/api/v1/content' }
    
    it "returns contents" do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it "returns 200 status code" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /contents/:id" do
    before { get "/api/v1/contents/#{content_id}" }

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

  describe "POST /contents" do
    # Valid payload
    let(:valid_payload) do
      { 
        title: 'Along the way of Tshorolpa',
        body: 'The staircases along the way was like way to heaven'
      }
    end

    context "with valid request attributes" do
      before { post '/api/v1/contents', params: valid_payload }
      
      it "returns 201 status code" do
        expect(response).to have_http_status(201)
      end
    end

    context "with invalid request attributes" do
      before { post '/api/v1/contents', params: {} }

      it "returns 422 status code" do
        expect(response).to have_http_status(422)
      end

      it "returns a failure message" do
        expect(response.body).to include("can't be blank")
      end
    end
  end

  describe "PUT /contents/:id" do
    let(:valid_payload) { { title: 'Across Langtang' } }
    before { put "/api/v1/contents/#{content_id}", params: valid_payload }

    context "when the content exists" do
      it "returns 204 status code" do
        expect(response).to have_http_status(204)
      end
      it "updates the content" do
        updated_content = Content.find(content_id)
        expect(updated_content.title).to match(/Across Langtang/)
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

  describe "DELETE /api/v1/contents/:id" do
    before { delete "/api/v1/contents/#{content_id}" }
    it "returns 204 status code" do
      expect(response).to have_http_status(204)
    end
  end
end
