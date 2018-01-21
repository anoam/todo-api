class TasksController < ApplicationController
  def index
    @collection = Task.where(board_id: params[:board_id])
    @collection =
      case params['type']
      when 'completed'
        @collection.completed
      when 'incompleted'
        @collection.incompleted
      else
        @collection
      end
   
    render json: @collection
  end

  def show
    @resource = Task.find(params[:id])
    render json: @resource
  end

  def create
    @resource = Task.create(resource_params.merge(board_id: params[:board_id]))
    render json: @resource
  end

  def complete
    @resource = Task.find(params[:id])
    @resource.update(completed_at: Time.now)
    render json: @resource
  end

  def update
    @resource = Task.find(params[:id])
    @resource.update(resource_params)
    render json: @resource
  end

  def destroy
    @resource = Task.find(params[:id])
    @resource.destroy
    render json: @resource
  end

  private

  def resource_params
    params.require(:task).permit(:title, :description)
  end
end
