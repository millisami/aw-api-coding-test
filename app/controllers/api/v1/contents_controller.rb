module Api::V1
  class ContentsController < ApplicationController
    # TODO: Have to delete this before action and wire it up with authentication
    skip_before_action :authenticated!
    before_action :set_content, only: %i[show update destroy]

    # GET /content
    def index
      @contents = Content.all
      render json: V1::ContentSerializer.new(@contents), status: :ok
    end

    # GET /contents/:id
    def show
      render json: V1::ContentSerializer.new(@content)
    end

    # POST /contents
    def create
      @content = Content.new(content_params)
      if @content.save
        render json: V1::ContentSerializer.new(@content), status: :created
      else
        render json: @content.errors, status: :unprocessable_entity
      end
    end

    # PUT /contents/:id
    def update
      @content.update(content_params)
      head :no_content
    end

    # DELETE /contents/:id
    def destroy
      @content.destroy
      head :no_content
    end
    
    private
    
    def content_params
      params.permit(:title, :body)
    end
    
    def set_content
      @content = Content.find(params[:id])
    end
  end
end