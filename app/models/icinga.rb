class Icinga
  def self.find(name)
    uri = URI.parse("http://mon01/cgi-bin/icinga/status.cgi?hostgroup=all&style=hostdetail&nostatusheader&jsonoutput")
    client = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    req.basic_auth 'icingaadmin', ''
    resp = client.request(req)
    JSON.parse(resp.body)["status"]["host_status"].each do |host|
      if host["host"] == name
        return host
      end
    end
    nil
  end
end
