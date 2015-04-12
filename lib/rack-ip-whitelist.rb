require "rack-ip-whitelist/version"
require 'rack-ip-whitelist/netaddr_list'

module Rack
  class IpWhitelist
    
    def initialize(app, optns={})
      addresses = optns[:ips]
      hostnames = optns[:hostnames]
      @app = app
      @ips = NetaddrList.parse addresses || ENV['WHITELISTED_IPS'], hostnames || ENV['WHITELISTED_HOSTNAMES']
      Rails.logger.info "[rack.ipwhitelist] whitelist: #{@ips.inspect}" if defined? Rails
    end

    def call(env)
      if white_listed?(env)
        @app.call(env)
      else
        body = defined?(Rails) ?  ::File.open(::File.join(Rails.root, 'public', '403.html'), 'r'): '<p>You are not authorized to view this site</p>'
        Rails.logger.info "[rack.ipwhitelist] sending 403 body" if defined?(Rails)
        [ 403, {"Content-Type" => "text/html"}, body]
      end
    end
    
    def white_listed?(env)
      address = env["HTTP_X_FORWARDED_FOR"] || env["REMOTE_ADDR"]
      allowed = @ips.contains? address
      Rails.logger.info "[rack.ipwhitelist] access for remote ip #{address.inspect} #{allowed ? 'granted' : 'denied'}" if defined?(Rails)
      allowed
    end

  end
end
