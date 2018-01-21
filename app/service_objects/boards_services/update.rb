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
      @board ||= find_service.board.tap { |board| board.update(params) }
    end

    def errors
      board.errors.full_messages
    end

    private

    attr_reader :id, :params

    def find_service
      @find_service ||= Find.new(id)
    end
  end
end
