module TasksServices
  class FindMultiple

    delegate :found?, to: :board_search

    def initialize(board_id)
      @board_id = board_id
    end

    def tasks
      return [] unless found?

      task_collection
    end

    private
    attr_reader :board_id
    delegate :board, to: :board_search

    def board_search
      @board_search ||= BoardsServices.search_service(board_id)
    end

    def task_collection
      board.tasks
    end

  end
end
