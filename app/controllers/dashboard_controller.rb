class DashboardController < ApplicationController
  def index
    render_success total_boards: dashboard_service.total_boards, total_tasks: dashboard_service.total_tasks, total_incomplete_tasks: dashboard_service.total_incomplete_tasks
  end

  private

  def dashboard_service
    @dashboard_service ||= DashboardServices.new_dashboard
  end
end
