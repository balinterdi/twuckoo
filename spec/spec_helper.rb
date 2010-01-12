require File.join(File.dirname(__FILE__), '..', 'lib', 'twuckoo')

require "spec"
require "mocha"

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
