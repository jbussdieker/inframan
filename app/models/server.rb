class Server
  def self.all
    Provider.first['us-west-1'].servers
  end

  def initialize(item=nil)
    @data = item
  end

  def name
    @data.tags["Name"]
  end

  def status
    @data.status
  end

  def id
    @data.id
  end

  def to_s
    name
  end
end
