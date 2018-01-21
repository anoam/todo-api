module TasksServices

  class FindOne
    def initialize(id)
      @id = id
    end

    def found?
      task.present?
    end

    def task
      return @task if @searched

      @searched = true
      @task = tasks.find_by(id: id)
    end

    private
    attr_reader :id

    def tasks
      Task
    end

  end
end
