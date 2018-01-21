class ApplicationController < ActionController::Base

  private

  def render_success(data, status = :ok)
    render json: { data: data }, status: status
  end

  def render_error(errors, status)
    render json: { errors: Array(errors) }, status: status
  end

  def render_unprocessable_entity(service)
    render_error service.errors, :unprocessable_entity
  end

end
