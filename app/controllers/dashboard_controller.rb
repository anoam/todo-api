class DashboardController < ApplicationController
  def index
    total_boards = Board.all.count
    
    total_tasks = Board.all.inject(0) do |a, e|
      a += e.tasks.count
    end

    total_incomplete_tasks = Board.all.inject(0) do |a, e|
      a += e.tasks.where(completed_at: nil).count
    end

    render json: { total_boards: total_boards, total_tasks: total_tasks, total_incomplete_tasks: total_incomplete_tasks }
  end
end
