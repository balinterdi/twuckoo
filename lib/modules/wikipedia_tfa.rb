require "open-uri"
require "hpricot"

# Grabs the headline of Wikipedia's Today's Featured Article (TFA)
module WikipediaTFA

  WIKIPEDIA_HOST = "http://en.wikipedia.org"

  def load_tweets
  end

  def store(line)
  end

  def fetch_main_page
    Hpricot(open("#{WIKIPEDIA_HOST}/wiki/Main_Page"))
  end

  def fetch_tfa
    doc = fetch_main_page
    tfa = doc.at("#mp-tfa b a")
    tfa_link = WIKIPEDIA_HOST + tfa["href"]
    "#{tfa.inner_html}: #{tfa_link}"
  end

  def next
    prev_tweet = get_last_tweet
    next_tweet = fetch_tfa
    return prev_tweet == next_tweet ? '' : next_tweet
  end
  
  private
  def get_last_tweet
    last_tweet = twitter.timeline_for(:me).first
    last_tweet.text if last_tweet
  end
end