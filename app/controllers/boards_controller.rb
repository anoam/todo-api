class BoardsController < ApplicationController

  def index
    render json: Board.all
  end

  def show
    if !search_service.found?
      render_not_found
    else
      render json: search_service.board
    end
  end

  def create
    if !create_service.params_valid?
      render_unprocessable_entity(create_service)
    else
      render json: create_service.board, status: :created
    end
  end

  def update
    if !update_service.found?
      render_not_found
    elsif !update_service.params_valid?
      render_unprocessable_entity(update_service)
    else
      render json: update_service.board
    end

  end

  def destroy
    if !delete_service.found?
      render_not_found
    else
      render json: '', status: :no_content
    end
  end

  private

  def render_not_found
    render json: { errors: "board not found" }, status: :not_found
  end

  def render_unprocessable_entity(service)
    render json: { errors: service.errors }, status: :unprocessable_entity
  end

  def search_service
    @search_service ||= BoardsServices.search_service(params[:id])
  end

  def create_service
    @create_service ||= BoardsServices.create_service(board_params)
  end

  def update_service
    @update_service ||= BoardsServices.update_service(params[:id], board_params)
  end

  def delete_service
    @delete_service ||= BoardsServices.delete_service(params[:id])
  end

  def board_params
    params.require(:board).permit(:title, :description)
  end
end
