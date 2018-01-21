module TasksServices

  class FindCompleted < FindMultiple

    private

    def task_collection
      super.completed
    end

  end
end
