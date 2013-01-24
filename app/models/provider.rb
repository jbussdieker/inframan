class Provider < ActiveRecord::Base
  attr_accessible :access_key, :name, :secret_access_key
  before_create :validate_creds
  after_create :populate_regions
  has_many :regions

  def populate_regions
    ec2 = AWS::EC2.new(:access_key_id => access_key, :secret_access_key => secret_access_key)
    ec2.regions.each do |aws_region|
      region = Region.where(:name => aws_region.name, :provider_id => id)
      if region.length > 0
        #region.update(:name => region.name)
      else
        Region.create(:name => aws_region.name, :provider_id => id)
      end
    end
  end

  def validate_creds
    begin
      ec2 = AWS::EC2.new(:access_key_id => access_key, :secret_access_key => secret_access_key)
      ec2.regions.collect {|v|v}
      true
    rescue AWS::EC2::Errors::AuthFailure => e
      errors.add(:keys, "Invalid keys")
      false
    end
  end

  def ec2
    AWS::EC2.new(:access_key_id => access_key, :secret_access_key => secret_access_key)
  end

  def to_s
    name
  end
end
