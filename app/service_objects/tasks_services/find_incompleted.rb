module TasksServices

  class FindIncompleted < FindMultiple

    private

    def task_collection
      super.incompleted
    end

  end
end
