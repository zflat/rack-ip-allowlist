$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'rack'
require 'rack-ip-allowlist'

def env_for url, opts={}
  Rack::MockRequest.env_for(url, opts)
end

# Use i18n-spec if locales are added to the gem
# I18n.enforce_available_locales = false
# require 'i18n-spec'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
end


# See testing strategy for Rack app at
# http://taylorluk.com/post/54982679495/how-to-test-rack-middleware-with-rspec
