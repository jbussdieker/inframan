class Region
  def initialize(item)
    @data = item
  end

  def servers
    @data.instances.collect do |instance|
      Server.new(instance)
    end
  end
end
