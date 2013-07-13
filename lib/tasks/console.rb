require 'bundler/setup'
require 'pry'

desc "Launch a pry console with all dependencies loaded"
task :console do
  pry
end
