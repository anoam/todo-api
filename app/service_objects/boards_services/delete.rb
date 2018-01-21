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

    private
    attr_reader :id

    def run
      return unless found?
      find_service.board.tap(&:destroy)
    end

    def find_service
      @find_service ||= Find.new(id)
    end
  end
end
