class BoardsController < ApplicationController

  def index
    render json: Board.all
  end

  def show
    render json: search_service.board
  end

  def create
    render json: create_service.board
  end

  def update
    render json: update_service.board
  end

  def destroy
    render json: delete_service.board
  end

  private

  def search_service
    @search_service ||= BoardsServices.search_service(params[:id])
  end

  def create_service
    @create_service ||= BoardsServices.create_service(params.require(:board).permit(:title, :description))
  end

  def update_service
    @update_service ||= BoardsServices.update_service(params[:id], require(:board).permit(:title, :description))
  end

  def delete_service
    @delete_service || BoardsServices.delete_service(params[:id])
  end
end
