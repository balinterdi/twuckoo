class Twuckoo::Runner
  # the idea is to include a module with a well-defined API with three methods:
  # - load_tweets
  # - next
  # - store(tweet)

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

  def initialize
    super
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

  def config
    @config ||= ::Twuckoo::Config.new
  end
  
  def tweet(message)
    unless message.nil? or message.empty?
      store(message)
      send_tweet(message)
    end
    message
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
