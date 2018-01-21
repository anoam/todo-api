module TasksServices
  class Update

    delegate :found?, to: :find_service

    def initialize(id, params)
      @id = id
      @params = params
    end

    def params_valid?
      task.valid?
    end

    def task
      @task ||= find_service.task.tap { |task| task.update(params) }
    end

    def errors
      task.errors.full_messages
    end

    private
    attr_reader :id, :params

    def find_service
      @find_service ||= FindOne.new(id)
    end
  end
end
