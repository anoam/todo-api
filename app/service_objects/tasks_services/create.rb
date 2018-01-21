module TasksServices

  class Create

    delegate :found?, to: :board_search_service

    def initialize(board_id, params)
      @board_id = board_id
      @params = params
    end

    def valid?
      return false unless task

      task.valid?
    end

    def errors
      return [] unless task

      task.errors.full_messages
    end

    def task
      return unless found?

      @task ||= tasks.create(params)
    end

    private
    attr_reader :board_id, :params
    delegate :board, to: :board_search_service

    def board_search_service
      @board_search_service ||= BoardsServices.search_service(board_id)
    end

    def tasks
      board.tasks
    end
  end

end
