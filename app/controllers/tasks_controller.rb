class TasksController < ApplicationController
  def index
    render json: find_multiple_service.tasks
  end

  def show
    render json: find_one_service.task
  end

  def create
    render json: create_service.task
  end

  def complete
    render json: complete_service.task
  end

  def update
    render json: update_service.task
  end

  def destroy
    render json: delete_service.task
  end

  private

  def task_params
    params.require(:task).permit(:title, :description)
  end

  def find_multiple_service
    @find_multiple_service ||= TasksServices.multiple_search(params[:board_id], params[:type])
  end

  def find_one_service
    @find_one_service ||= TasksServices.find(params[:id])
  end

  def create_service
    @create_service ||= TasksServices.create(params[:board_id], task_params)
  end

  def complete_service
    @complete_service ||= TasksServices.complete(params[:id])
  end

  def update_service
    @update_service ||= TasksServices.update(params[:id], task_params)
  end

  def delete_service
    @delete_service ||= TasksServices.delete(params[:id])
  end
end
