require "rack-ip-allowlist/version"
require 'rack-ip-allowlist/netaddr_list'

module Rack
  class IpAllowlist
    
    def initialize(app, optns={})
      addresses = optns[:ips]
      hostnames = optns[:hostnames]
      @app = app
      @ips = NetaddrList.parse addresses || ENV['ALLOWLISTED_IPS'], hostnames || ENV['ALLOWLISTED_HOSTNAMES']
      Rails.logger.info "[rack.ipallowlist] allowlist: #{@ips.inspect}" if defined? Rails
    end

    def call(env)
      if white_listed?(env)
        @app.call(env)
      else
        body = defined?(Rails) ?  ::File.open(::File.join(Rails.root, 'public', '403.html'), 'r'): '<p>You are not authorized to view this site</p>'
        Rails.logger.info "[rack.ipallowlist] sending 403 body" if defined?(Rails)
        [ 403, {"Content-Type" => "text/html"}, body]
      end
    end
    
    def white_listed?(env)
      # removed x-forwarded-for based on the need to filter for trusted proxies
      # see http://blog.gingerlime.com/2012/rails-ip-spoofing-vulnerabilities-and-protection
      # https://github.com/steveklabnik/rails/blob/75dcdbc84e53cd824c4f1c3e4cb82c40f27010c8/actionpack/lib/action_dispatch/middleware/remote_ip.rb
      address = env["REMOTE_ADDR"]
      allowed = !(address.nil? || address.length<1) && (@ips.contains? address)
      Rails.logger.info "[rack.ipallowlist] access for remote ip #{address.inspect} #{allowed ? 'granted' : 'denied'}" if defined?(Rails)
      allowed
    end

  end
end
