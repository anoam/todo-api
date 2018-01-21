class BoardsController < ApplicationController

  def index
    @collection = Board.all
    render json: @collection
  end

  def show
    @resource = Board.where(:id => params[:id]).first
    render json: @resource
  end

  def create
    @resource = Board.create(params[:board])
    render json: @resource
  end

  def update
    @resource = Board.where(:id => params[:id]).first
    @resource.update(params[:board])
    render json: @resource
  end

  def destroy
    @resource = Board.where(:id => params[:id]).first
    @resource.destroy
    render json: @resource
  end
end
