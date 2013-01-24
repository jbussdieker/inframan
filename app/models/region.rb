class Region < ActiveRecord::Base
  attr_accessible :name, :provider_id

  belongs_to :provider
  has_many :servers

  def ec2
    provider.ec2.regions[name]
  end

  def populate_servers
    provider.ec2.regions[name].instances.each do |instance|
      if instance.status == :running
        server = Server.where(:instance_id => instance.id)
        if server.length > 0
          server.first.update_attributes(:name => instance.tags["Name"],
            :region_id => id,
            :public_ip => instance.public_ip_address,
            :private_ip => instance.private_ip_address,
            :instance_id => instance.id)
        else
          Server.create(:name => instance.tags["Name"], 
            :region_id => id,
            :public_ip => instance.public_ip_address,
            :private_ip => instance.private_ip_address,
            :instance_id => instance.id)
        end
      end
    end
  end

  def to_s
    name
  end
end
