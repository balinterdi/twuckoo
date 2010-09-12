require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "twuckoo"
    gemspec.summary = "Need to tweet periodically in an automated fashion? Then Twuckoo is for you!"
    gemspec.description = <<-EOF
      A simple yet elegant solution to tweet a message regularly from a file (or from a webpage, a database, etc.)
    EOF
    gemspec.email = "balint.erdi@gmail.com"
    gemspec.homepage = "http://github.com/balinterdi/twuckoo"
    gemspec.authors = ["Balint Erdi"]
    gemspec.add_development_dependency("mocha",  ">= 0.9.5")
    gemspec.add_development_dependency("rspec")
    gemspec.add_dependency("twitter_oauth", "~> 0.4.3")
    gemspec.add_dependency("hpricot", ">= 0.6.164")
    gemspec.add_dependency("mail", ">= 1.6.0")
    gemspec.add_dependency("tlsmail", ">= 0.0.1")
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

