module BoardsServices
  class Find

    def initialize(id)
      @id = id
    end

    def board
      return @board if @searched

      @searched = true
      @board = boards.find_by(id: id)
    end

    def found?
      !board.nil?
    end

    private
    attr_reader :id

    def boards
      Board
    end
  end
end
