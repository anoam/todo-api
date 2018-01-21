class BoardsController < ApplicationController

  def index
    render_success Board.all
  end

  def show
    if !search_service.found?
      render_not_found
    else
      render_success search_service.board
    end
  end

  def create
    if !create_service.params_valid?
      render_unprocessable_entity(create_service)
    else
      render_success create_service.board, :created
    end
  end

  def update
    if !update_service.found?
      render_not_found
    elsif !update_service.params_valid?
      render_unprocessable_entity(update_service)
    else
      render_success update_service.board
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
    render_error "board not found", :not_found
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
