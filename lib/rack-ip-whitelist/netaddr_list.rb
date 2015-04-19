require "netaddr"
require 'resolv'

class NetaddrList

  HOSTNAME_RESOLV_ATTEMPTS = 10
  
  def self.parse addresses, hostnames=nil
    addresses ||= ''
    hostnames ||= ''
    ip_list = addresses.split(',').collect {|address|
      if address['..'].nil?
        NetAddr.wildcard(address)
      else
        ips = address.split '..'
        NetAddr.wildcard(ips.first)..NetAddr.wildcard(ips.last)
      end
    } | hostnames.split(',').collect {|hostname|
      h = nil
      (1..HOSTNAME_RESOLV_ATTEMPTS).each do |attempt|
        begin
          h = ::Resolv.getaddress(hostname) 
          break if h
          sleep(0.05)
        rescue => e
          message = "[rack.ipwhitelist.netaddr_list]: Could not resolve address for #{hostname} on attempt #{attempt}"
          Rails.logger.warn message  if defined? Rails
          puts e.message
        end
      end # (1..HOSTNAME_RESOLV_ATTEMPTS).each
      if h; NetAddr.wildcard(h) else nil end
    }.select{|entry| !entry.nil?}
    self.new ip_list
  end
  
  def initialize cidrs_list
    @cirds_list = cidrs_list
  end
  
  def contains? ip
    ip && ip.length>0 && !@cirds_list.find do |item|
      if item.is_a? Range
        item.include? ip
      elsif item.is_a? NetAddr::CIDR
        item.cmp ip
      end
    end.nil?
  end
  
end
