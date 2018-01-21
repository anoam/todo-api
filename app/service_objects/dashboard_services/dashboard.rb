module DashboardServices
  class Dashboard

    def total_boards
      @total_boards ||= Board.all.count
    end

    def total_tasks
      @total_tasks ||= Board.all.inject(0) do |a, e|
        a += e.tasks.count
      end
    end

    def total_incomplete_tasks
      @total_incomplete_tasks ||= Board.all.inject(0) do |a, e|
        a += e.tasks.where(completed_at: nil).count
      end
    end

  end
end
