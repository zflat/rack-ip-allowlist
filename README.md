# IP Allowlist Middleware

## About

Rack Middleware for websites that need to contain access to a group of ip addresses (a allowlist). 
Outside these addresses, vistors are shown 403 Forbidden page.

### Features

* Allowlist hostnames or ip addresses
* Multiple options for providing the allowlist (see usage)
* Uses HTTP_X_FORWARDED_FOR as well as backing up with REMOTE_ADDR
* Supports wildcards, single ips and ranges
* 403 error document read from rails /public directory when used in rails


### Usage

#### Rails 3, 4

in Gemfile

      gem 'rack-ip-allowlist'

in config/application.rb

      # array of allowlisted addresses
      config.middleware.use Rack::IpAllowlist, :ips=>'55.44.22.11,55.44.11.22'
      
      # array of allowlisted hostnames
      config.middleware.use Rack::IpAllowlist, :hostnames=>'domain1.com,domain2.com'
      
      # allowlist ips specified in the env
      ENV['ALLOWLISTED_IPS']
      config.middleware.use Rack::IpAllowlist

      # allowlist hostnames specified in the env
      ENV['ALLOWLISTED_HOSTNAMES']
      config.middleware.use Rack::IpAllowlist


#### TODO: With a proxy

Not yet implemented.

    # Specify trusted proxy IPs as a comma separated list
    ENV['ALLOWLISTED_TRUSTED_PROXY_IPS']


## Testing

Run tests with colored and documented format:

    bundle exec rspec spec -c -fd

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

