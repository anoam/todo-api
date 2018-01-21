module DashboardServices
  class Dashboard

    def total_boards
      @total_boards ||= all_boards.count
    end

    def total_tasks
      @total_tasks ||= all_tasks.count
    end

    def total_incomplete_tasks
      @total_incomplete_tasks ||= all_tasks.incompleted.count
    end

    def all_boards
      Board
    end

    def all_tasks
      Task
    end
  end
end
