class TasksController < ApplicationController

  def index
    if !find_multiple_service.found?
      render_board_not_found
    else
      render_success find_multiple_service.tasks
    end
  end

  def show
    if !find_one_service.found?
      render_task_not_found
    else
      render_success find_one_service.task
    end
  end

  def create
    if !create_service.found?
      render_board_not_found
    elsif !create_service.params_valid?
      render_unprocessable_entity(create_service)
    else
      render_success create_service.task, :created
    end
  end

  def complete
    if !complete_service.found?
      render_task_not_found
    elsif !complete_service.params_valid?
      render_unprocessable_entity complete_service
    else
      render_success complete_service.task
    end
  end

  def update
    if !update_service.found?
      render_task_not_found
    elsif !update_service.params_valid?
      render_unprocessable_entity update_service
    else
      render_success update_service.task
    end
  end

  def destroy
    if !delete_service.found?
      render_task_not_found
    else
      render json: '', status: :no_content
    end
  end

  private

  def render_task_not_found
    render_error "task not found", :not_found
  end

  def render_board_not_found
    render_error "board not found", :not_found
  end

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
