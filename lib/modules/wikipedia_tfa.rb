require "open-uri"
require "hpricot"

module WikipediaTFA
  
  WIKIPEDIA_HOST = "http://en.wikipedia.org"
  
  def load_tweets
  end

  def store(line)
  end

  def get_wikipedia_main_page
    Hpricot(open("#{WIKIPEDIA_HOST}/wiki/Main_Page"))
  end
  
  def next
    doc = get_wikipedia_main_page
    tfa = doc.at("#mp-tfa p b a")
    tfa_link = WIKIPEDIA_HOST + tfa["href"]
    "#{tfa.inner_html}: #{tfa_link}"
  end
end