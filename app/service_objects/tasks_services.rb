module TasksServices

  def self.multiple_search(board_id, type)
    case type
    when 'completed'
      FindCompleted.new(board_id)
    when 'incompleted'
      FindIncompleted.new(board_id)
    else
      FindMultiple.new(board_id)
    end
  end

  def self.find(id)
    FindOne.new(id)
  end

  def self.create(board_id, params)
    Create.new(board_id, params)
  end

  def self.complete(id)
    Complete.new(id).tap{ |s| s.send(:run)}
  end

  def self.update(id, params)
    Update.new(id, params)
  end

  def self.delete(id)
    Delete.new(id).tap{ |s| s.send(:run)}
  end
end
