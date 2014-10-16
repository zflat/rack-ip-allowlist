require "rack-ip-whitelist/version"
require 'rack-ip-whitelist/netaddr_list'

module Rack
  class IpWhitelist
    
    def initialize(app, addresses=nil)
      @app = app
      @ips = NetaddrList.parse addresses || ENV['WHITELISTED_IPS']
      Rails.logger.info "[rack.ipwhitelist] whitelist: #{@ips.inspect}" if defined? Rails
    end

    def call(env)
      if white_listed?(env)
        @app.call(env)
      else
        body = defined?(Rails) ?  ::File.open(::File.join(Rails.root, 'public', '403.html'), 'r'): '<p>You are not authorized to view this site</p>'
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
