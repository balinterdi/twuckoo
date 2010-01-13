require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "twuckoo"
    gemspec.summary = "Need to tweet periodically in an automated fashion? Then Twuckoo is for you!"
    gemspec.description = <<-EOF
      A simple yet elegant solution to tweet a message regularly from a file (from a webpage, a database, etc.)
    EOF
    gemspec.email = "balint.erdi@gmail.com"
    gemspec.homepage = "http://github.com/balinterdi/twuckoo"
    gemspec.authors = ["Balint Erdi"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

