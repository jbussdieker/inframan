class Provider < ActiveRecord::Base
  attr_accessible :access_key, :name, :secret_access_key

  def ec2
    AWS::EC2.new(:access_key_id => access_key, :secret_access_key => secret_access_key)
  end

  def [](region)
    Region.new(ec2.regions[region])
  end

  def regions
    ec2.regions.collect {|v| Region.new(v)}
  end
end
