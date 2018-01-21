module BoardsServices
  class Delete

    delegate :found?, to: :find_service

    def initialize(id)
      @id = id
    end


    def success?
      return false unless found?

      board.destroyed?
    end

    # for legacy
    def board
      return unless found?
      find_service.board.tap(&:destroy)
    end

    private
    attr_reader :id

    def find_service
      @find_service ||= Find.new(id)
    end
  end
end
