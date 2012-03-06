require "rack-ip-whitelist/version"

module Rack
  class IpWhitelist
    def initialize(app, addresses=nil)
      @app = app
      env_ips = ENV.include?('WHITELISTED_IPS') ? ENV['WHITELISTED_IPS'].split(',') : []
      @ip_addresses = addresses || env_ips
    end

    def call(env)
      if white_listed?(env)
        @app.call(env)
      else
        [ 200, {"Content-Type" => "text/html"}, ["<p>You are not authorized to view this site</p>"] ]
      end
    end
    
    def white_listed?(env)
      allowed = ENV.include?('WHITELISTED_IPS') ? @ip_addresses.include?(env["REMOTE_ADDR"]) : true
      address = env["HTTP_X_FORWARDED_FOR"] || env["REMOTE_ADDR"]
      Rails.logger.info "[rack.ipwhitelist] access for remote ip #{address.inspect} #{allowed ? 'granted' : 'denied'}"
      allowed
    end

  end
end
