require "optparse"
require "ostruct"
require "mail"

require 'bundler/setup'

module Twuckoo
  class Exception < StandardError
  end
end

class Twuckoo::Runner
  # the idea is to instantiate a feeder with a well-defined API:
  # - setup
  # - load_tweets (TODO: merge into setup)
  # - next
  # - store(tweet)

  def run
    setup_from_file
    @feeder.load_tweets
    next_tweet = @feeder.next
    #TODO: Fetching @feeder.next twice seems too complicated
    p next_tweet
    while (next_tweet and !tweet_limit_reached?) do
      tweet(next_tweet)
      wait if wait_between_tweets?
      next_tweet = @feeder.next
      if next_tweet.nil?
        send_email(name, config)
        @feeder.reset
        next_tweet = @feeder.next
      end
    end
  end

  attr_accessor :tweets_sent

  def initialize(feeder_class, tweeter_module=nil, args=[])
    #TODO: Fail if feeder_class is nil or better: parse options first
    unless feeder_class.nil?
      feeder_class = self.class.get_feeder_class(feeder_class)
      @feeder = feeder_class.new
    end

    #TODO: This should be stored in the tweeter, not the runner
    @tweets_sent = 0

    # tweeter_module should be a class instance instead. Then everything falls into place
    @tweeter_module = tweeter_module.nil? ? Twuckoo::TwitterOauth : tweeter_module

    @options = OpenStruct.new
    parse_options!(args)
    @feeder.setup
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

    opts.parse!(args)
  end

  def name
    @options.name || File.split(File.dirname(__FILE__)).last
  end

  def wait_between_tweets?
    config[:time_to_sleep] != "0"
  end

  def wait
    seconds_to_sleep = Twuckoo::DurationString.to_seconds(config[:time_to_sleep])
    sleep(seconds_to_sleep)
  end

  def tweet(message)
    send_tweet(message, config)
    inc_tweet_counter
    @feeder.store(message)
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
  def self.get_feeder_class(name)
    case name
    when "file", "from_file"
      Twuckoo::OneLineFromFile
    when "wikipedia_tfa"
      Twuckoo::WikipediaTFA
    else
      raise Twuckoo::Exception, "Invalid feeder class: #{name}"
    end
  end

  def tweeter_module
    @tweeter_module
  end

  def send_tweet(message, options)
    tweeter_module._tweet(message, options)
  end

  def inc_tweet_counter
    @tweets_sent += 1
  end

  def tweet_limit_reached?
    !config[:tweet_limit].zero? and config[:tweet_limit].to_i == tweets_sent
  end

  def send_email(name, config)
    #FIXME: `initialize': Connection refused - connect(2) (Errno::ECONNREFUSED)
    # Maybe just get rid of the whole email sending thingie?
    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE, nil)
    Mail.defaults do
      delivery_method(:smtp, {
        host: "smtp.gmail.com",
        port: 25,
        user: config[:user],
        pass: config[:password],
        enable_starttls_auto: false
      })
    end

    Mail.deliver do
      from    'twuckoo@nowhere.com'
      to      config[:email]
      subject %([twuckoo]: instance "#{name}" has done a reset)
      body    "And is now going full speed again."
    end
  end
end
