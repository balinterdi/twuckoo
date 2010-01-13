require "optparse"
require "ostruct"

class TwuckooException < Exception
end

class Twuckoo::Runner
  # the idea is to include a module with a well-defined API with three methods:
  # - load_tweets
  # - next
  # - store(tweet)
  attr_reader :used_module

  def run
    setup_from_file
    load_tweets
    next_tweet = self.next
    while next_tweet do
      tweet(next_tweet)
      wait if wait_between_tweets?
      next_tweet = self.next
      notify if next_tweet.nil?
    end
  end

  def initialize(args=[])    
    @options = OpenStruct.new
    parse_options!(args)

    _module = args.pop
    use_module(get_module(_module))    
    super
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

    if args.length.zero?
      puts opts.banner
      exit
    end

    # opts.on_tail("--version", "Show version") do
    #   File.read(...)
    #   exit
    # end

    opts.parse!(args)    
  end
  
  def name
    @options.name
  end
  
  def wait_between_tweets?
    config[:time_to_sleep] != "0"
  end

  def wait
    seconds_to_sleep = DurationString.to_seconds(config[:time_to_sleep])
    sleep(seconds_to_sleep)
  end

  def notify
    send_email(config)
  end
  
  def tweet(message)
    unless message.nil? or message.empty?
      store(message)
      send_tweet(message)
    end
    message
  end

  def config
    @config ||= ::Twuckoo::Config.new
  end

  def get_config_values_from_file(file='config/cuckoo.yml')
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
        config[attr] = value
      end
    end
  end

  private
  def get_module(module_id)
    case module_id
    when "file"
      OneLineFromFile
    when "from_file"
      OneLineFromFile
    when "wikipedia_tfa"
      WikipediaTFA
    else
      raise TwuckooException, "Invalid module: #{module_id.inspect}"
    end
  end
  
  def use_module(_module)
    @used_module = _module
    self.class.class_eval { include _module }
  end

  def send_tweet(message)
    twitter.status(:post, message)
  end

  def send_email(config)
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
      subject "[twuckoo]: nothing more to tweet"
      body   "So please fill me up!"
    end
  end
end
