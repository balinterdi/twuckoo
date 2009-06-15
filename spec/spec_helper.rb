require "spec"
require "mocha"

dir = File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(dir, 'cuckoo_twitterer')
require File.join(dir, 'environments')

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
