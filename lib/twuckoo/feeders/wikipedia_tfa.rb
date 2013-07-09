require "open-uri"
require "hpricot"

# Grabs the headline of Wikipedia's Today's Featured Article (TFA)
module Twuckoo
  class WikipediaTFA

    WIKIPEDIA_HOST = "http://en.wikipedia.org"

    def setup
    end

    def load_tweets; end
    def store(line); end
    def reset; end

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
      prev_tweet = twitter_module.latest_tweet(config)
      next_tweet = fetch_tfa
      prev_tweet == next_tweet ? '' : next_tweet
    end

  end
end
