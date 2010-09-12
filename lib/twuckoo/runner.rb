require "optparse"
require "ostruct"
require "mail"

class TwuckooException < Exception
end

class Twuckoo::Runner
  # the idea is to include a module with a well-defined API with three methods:
  # - load_tweets
  # - next
  # - store(tweet)

  def run
    setup_from_file
    load_tweets
    next_tweet = self.next
    while (next_tweet and !tweet_limit_reached?) do
      tweet(next_tweet)
      wait if wait_between_tweets?
      next_tweet = self.next
      if next_tweet.nil?
        notify
        reset
        next_tweet = self.next
      end
    end
  end

  attr_accessor :tweets_sent

  def initialize(module_name, twitter_module=nil, args=[])
    unless module_name.nil?
      _module = self.class.get_module(module_name)
      class_eval { include _module }
    end
    @tweets_sent = 0
    @twitter_module = twitter_module.nil? ? Twuckoo::TwitterOauth : twitter_module
    @options = OpenStruct.new
    parse_options!(args)
    setup_for_module
  end

  def parse_options!(args)
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: twuckoo [options] module_to_use"
      opts.on("-n name", "--name name",
              "name will be the name of this twuckoo instance (used for email notifs)") do |name|
        @options.name = name
      end
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end

    # opts.on_tail("--version", "Show version") do
    #   File.read(...)
    #   exit
    # end

    opts.parse!(args)
  end

  def name
    @options.name || File.split(File.dirname(__FILE__)).last
  end

  def wait_between_tweets?
    config[:time_to_sleep] != "0"
  end

  def wait
    seconds_to_sleep = DurationString.to_seconds(config[:time_to_sleep])
    sleep(seconds_to_sleep)
  end

  def notify
    send_email(name, config)
  end

  def tweet(message)
    unless message.nil? or message.empty?
      begin
        send_tweet(message, config)
      rescue @twitter_module.exception
        return message
      else
        inc_tweet_counter
        store(message)
      end
    end
    message
  end

  def config
    @config ||= ::Twuckoo::Config.new
  end

  def get_config_values_from_file(file='config/twuckoo.yml')
    begin
      open(file, 'r') do |f|
        YAML.load(f.read)
      end
    rescue
      {}
    end
  end

  def setup
    yield config
  end

  def setup_from_file
    setup do |config|
      get_config_values_from_file.each_pair do |attr, value|
        config[attr.to_sym] = value
      end
    end
  end

  private
  def self.get_module(module_name)
    case module_name
    when "file"
      OneLineFromFile
    when "from_file"
      OneLineFromFile
    when "wikipedia_tfa"
      WikipediaTFA
    else
      raise TwuckooException, "Invalid module: #{module_name.inspect}"
    end
  end

  def send_tweet(message, options)
    @twitter_module._tweet(message, options)
  end

  def inc_tweet_counter
    @tweets_sent += 1
  end

  def tweet_limit_reached?
    !config[:tweet_limit].zero? and config[:tweet_limit].to_i == tweets_sent
  end

  def send_email(name, config)
    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
    Mail.defaults do
      smtp do
        host "smtp.gmail.com"
        port 25
        user config[:user]
        pass config[:password]
        disable_tls
      end
    end

    Mail.deliver do
      from 'twuckoo@nowhere.com'
      to config[:email]
      subject %([twuckoo]: instance "#{name}" has done a reset)
      body   "And is now going full speed again."
    end
  end
end
