module TasksServices
  class Complete

    attr_reader :errors
    delegate :found? , to: :search_service

    def initialize(id)
      @id = id
      @errors = []
    end


    def task
      search_service.task
    end

    private

    attr_reader :id
    attr_writer :errors

    def search_service
      @search_service ||= FindOne.new(id)
    end

    def run
      return unless found?
      unless task.can_complete?
        error.push("can't complete")
        return
      end

      task.complete!
      task.save!
    end
  end
end
