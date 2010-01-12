$:.unshift File.expand_path(File.dirname(__FILE__))

require 'vendor/gems/environment'

require 'environments'
require 'duration_string'
require 'modules'

Bundler.require_env

class Twuckoo
  # the idea is to include a module with a well-defined API with three methods:
  # - load_tweets
  # - next
  # - store(tweet)
  attr_writer :time_to_sleep

  def initialize
    @time_to_sleep = "1d"
    super
  end

  def time_to_sleep
    @time_to_sleep
  end

  def tweet(message)
    unless message.nil? or message.empty?
      store(message)
      send_tweet(message)
    end
    message
  end

  def get_config_values_from_file
    begin
      open('config/cuckoo.yml', 'r') do |f|
        YAML.load(f.read)
      end
    rescue
      {}
    end
  end

  def setup
    get_config_values_from_file.each_pair do |attr, value|
      self.send("#{attr}=".to_sym, value)
    end
  end

  def relax
    seconds_to_sleep = DurationString.to_seconds(time_to_sleep)
    sleep(seconds_to_sleep)
  end

  def run
    setup
    load_tweets
    next_tweet = self.next
    while next_tweet do
      tweet(next_tweet)
      relax
      next_tweet = self.next
      send_email if next_tweet.nil?
    end
  end

  private
  def send_tweet(message)
    twitter.status(:post, message)
  end
  
  def send_email
    
  end
end
