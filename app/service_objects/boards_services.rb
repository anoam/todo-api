# Collection of services for boards
module BoardsServices

  def self.search_service(id)
    Find.new(id)
  end

  def self.create_service(params)
    Create.new(params)
  end

  def self.update_service(id, params)
    Update.new(id, params)
  end

  def self.delete_service(id)
    Delete.new(id).tap { |s| s.send(:run) }
  end
end
