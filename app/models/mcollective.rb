require 'net/http'

class Mcollective
  def self.all
    uri = URI.parse("http://mq01:9292/rpcutil/ping")
    client = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    resp = client.request(req)
    JSON.parse(resp.body)
  end
end
