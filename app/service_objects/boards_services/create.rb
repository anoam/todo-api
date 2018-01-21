module BoardsServices

  class Create

    def initialize(params)
      @params = params
    end

    def params_valid?
      board.valid?
    end

    def board
      @board ||= boards.create(params)
    end

    def errors
      @errors ||= board.errors.full_message
    end

    private
    attr_reader :params

    def boards
      Board
    end
  end
end
