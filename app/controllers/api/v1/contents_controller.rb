module Api::V1
  class ContentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    # GET /content
    def index
      @contents = Content.all
      render json: V1::ContentSerializer.new(@contents), status: :ok
    end

    # GET /contents/:id
    def show
      @content = Content.find(params[:id])
      render json: V1::ContentSerializer.new(@content)
    end

    # POST /contents
    def create
      @content = current_user.contents.build(content_params)
      if @content.save
        render json: V1::ContentSerializer.new(@content), status: :created
      else
        render json: @content.errors, status: :unprocessable_entity
      end
    end

    # PUT /contents/:id
    def update
      @content = current_user.contents.find(params[:id])
      @content.update(content_params)
      render json: V1::ContentSerializer.new(@content), status: :ok
      # head :no_content
    end

    # DELETE /contents/:id
    def destroy
      @content = current_user.contents.find(params[:id])
      @content.destroy
      render json: { message: 'Deleted' }, status: :ok
    end
    
    private
    
    def content_params
      params.permit(:title, :body)
    end

    def record_not_found(e)
      render json: { error: e.message }, status: :not_found
    end
  end
end