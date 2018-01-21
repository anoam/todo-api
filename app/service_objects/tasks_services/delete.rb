module TasksServices

  class Delete
    delegate :found?, to: :find_service
    delegate :task, to: :find_service #legacy
    def initialize(id)
      @id = id
    end

    private
    attr_reader :id

    def run
      return unless found?
      task.tap(&:destroy)
    end

    def find_service
      @find_service ||= FindOne.new(id)
    end
  end
end
