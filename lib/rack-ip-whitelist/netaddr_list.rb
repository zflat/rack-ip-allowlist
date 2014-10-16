require "netaddr"

class NetaddrList
  
  def self.parse addresses
    addresses ||= ''
    new addresses.split(',').collect {|address|
      if address['..'].nil?
        NetAddr.wildcard(address)
      else
        ips = address.split '..'
        NetAddr.wildcard(ips.first)..NetAddr.wildcard(ips.last)
      end
    }
  end
  
  def initialize cidrs_list
    @cirds_list = cidrs_list
  end
  
  def contains? ip
    !@cirds_list.find do |item|
      if item.is_a? Range
        item.include? ip
      elsif item.is_a? NetAddr::CIDR
        item.cmp ip
      end
    end.nil?
  end
  
end
