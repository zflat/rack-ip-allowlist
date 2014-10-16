# IP Whitelist Middleware

## About

Rack Middleware for websites that need to contain access to a group of ip addresses (a whitelist). 
Outside these addresses, vistors are shown 403 Forbidden page.

### Features

* Multiple options for providing the whitelist (see usage)
* Uses HTTP_X_FORWARDED_FOR as well as backing up with REMOTE_ADDR
* Supports wildcards, single ips and ranges


### Usage

#### Rails 3, 4

in Gemfile

      gem 'rack-ip-whitelist'

in config/application.rb

      # array of whitelisted addresses
      config.middleware.use Rack::IpWhitelist, '55.44.22.11,55.44.11.22'
      
      # whitelist specified in the env
      ENV['WHITELISTED_IPS']
      config.middleware.use Rack::IpWhitelist

## Testing

Run tests with colored and documented format:

    bundle exec rspec spec -c -fd

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

