$:.unshift File.expand_path(File.dirname(__FILE__))

module Twuckoo

end

require 'environments'
require 'duration_string'
require 'modules'

require 'twuckoo/config'
require 'twuckoo/runner'
require 'twuckoo/twibot_module'
