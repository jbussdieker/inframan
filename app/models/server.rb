class Server
  extend ActiveModel::Naming
  include ActiveModel::Validations

  attr_accessor :id, :name, :type_id
  attr_accessor :private_ip, :public_ip

  def self.all
    Provider.first['us-west-1'].servers
  end

  def self.find(id)
    all.each do |server|
      if server.id == id
        return server
      end
    end
    nil
  end

  def create
    region = Provider.first['us-west-1']
    @data = region.instances.create({
      :image_id => 'ami-4e5f7c0b', 
      :key_name => 'master',
      :user_data => "#{self.name}:10.174.23.252",
      :security_groups => ['default', self.type_id],
      :instance_type => 'm1.small',
    })
    @data.tags["Name"] = self.name
  end

  def destroy
    if @data and @data.kind_of? AWS::EC2::Instance
      @data.terminate
    else
      raise "Invalid type #{@data}"
    end
  end

  def icinga
    Icinga.find(self.name) || {}
  end

  def initialize(item={})
    @data = item
    if item and item.kind_of? AWS::EC2::Instance
      self.name = item.tags["Name"]
      self.type_id = item.instance_type
      self.id = item.id
      self.public_ip = item.public_ip_address
      self.private_ip = item.private_ip_address
    else
      self.name = item[:name]
      self.type_id = item[:type_id]
    end
  end

  def status
    @data.status
  end

  def to_key
    id || nil
  end

  def persisted?
    @data.kind_of? AWS::EC2::Instance
  end

  def to_s
    name
  end
end
