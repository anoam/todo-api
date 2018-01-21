module BoardsServices

  class Update

    def initialize(id, params)
      @id = id
      @params = params
    end

    def found?
      find_service.found?
    end

    def params_valid?
      board.valid?
    end

    def board
      @board ||= find_service.board.tap { |board| board.update(board) }
    end

    def error
      board.errors.full_message
    end

    private

    attr_reader :id, :params

    def find_service
      @find_service ||= Find.new(id)
    end
  end
end
