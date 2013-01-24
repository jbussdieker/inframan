class Server < ActiveRecord::Base
  attr_accessible :name, :private_ip, :public_ip, :region_id, :instance_id, :image_id, :role, :master
  attr_accessor :role, :master
  before_create :provision_instance
  before_destroy :deprovision_instance

  belongs_to :region

  def deprovision_instance
    begin
      region.ec2.instances[instance_id].terminate
    rescue Exception => e
      errors.add(:provisioning, "Failed to deprovision")
      false
    end
  end

  def provision_instance
    return if instance_id
    begin
      instance = region.ec2.instances.create({
        :image_id => image_id, 
        :key_name => 'master',
        :user_data => "#{name}:#{self.master}",
        :security_groups => ['default', self.role],
        :instance_type => 'm1.small',
      })
      instance.tags["Name"] = name
      self.instance_id = instance.id
    rescue Exception => e
      errors.add(:provisioning, "Failed to create instance")
      false
    end
  end
end
