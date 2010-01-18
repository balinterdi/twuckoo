# Twuckoo

Need to tweet periodically and in an automated fashion? Then Twuckoo is for you. Still not convinced? :) Read on.

## Abstract

Twuckoo fulfills the task of periodically fetching a message and tweeting it (Twuckoo = Twitter + Cuckoo). Since we all prefer code to words, I'll show you its main loop:

    def run
      ...
      while next_tweet do
        tweet(next_tweet)
        wait if wait_between_tweets?
        next_tweet = self.next
        notify if next_tweet.nil?
      end
    end
    
It is very simple in its design but opens vast possibilities due to its modular approach.

## A simple API

Twuckoo takes a modular approach. It defines a very simple API and expects modules to implement these API methods. The methods are:

    * load_tweets

Loads the possible tweets that twuckoo will use when selecting the next one. This could be reading all lines from a file, for example.
    
    * next

Fetches the next message to be tweeted. Usually the bulk of the "business logic" is implemented here. This could be scraping a web page and extracting a specific snippet of html.
    
    * store(tweet)

Hands the last tweeted message to be stored. In the case of the one\_line\_from_file module, this stores the tweet in a file so that no message is used multiple times.
    
Twuckoo needs to be passed the name of the module to be used. At the moment there are two provided modules: 

* file

  Loads all the lines from a file (lines.txt) and tweets one line randomly each time.
  
* wikipedia_tfa

  Scraps Wikipedia's main page and extracts the name and link of Today's Featured Article. This is not as general a module as `file`. I am thinking about how to best make a "web" module out of this.

## Installation

    gem install twuckoo --source http://gemcutter.org
    
Twuckoo depends on twibot and a couple of other gems which will also get installed with the above command.

In order for twibot to be able to connect to your twitter account, a config/bot.yml file need to be present at where you launch twuckoo from. It has to contain the following lines at least:

    login: my_login
    password: my_password
    
For more options, see [twibot's README](http://github.com/cjohansen/twibot/tree/master "twibot's README")

## Configuration

Twuckoo's configuration options have to be written into `config/twuckoo.yml`. The current options are:

  * time_to_sleep
  
By default, it is "1d", so the script will "relax" for 24 hours after tweeting. The value should be given in a human-comprehensible form. You can use any combination of weeks, days, hours, minutes and seconds, so 1w3d13h27m19s will work, too, although you probably do not want to be this precise :)

  * user
  * password
  * email
  
When twuckoo is out of messages to tweet, it quits. Most of the times you'll want to get notified of this, though, so you can take action (e.g refill it and relaunch). If the above options are set, twuckoo sends an email to `email`, using the `user` and `password` credentials for gmail authentication. (Yes, currently only gmail is supported, I'll change that shortly.)

## Running

You have to indicate the module you wish to use:

    $ twuckoo file
    
Will make use of the `file` module. There has to be a lines.txt file in the directory where you run twuckoo from that contains the possible tweets, one tweet per line. The tweeted lines will be stored in a file called used\_lines.txt so you should have write permission to the directory.

or

    $ twuckoo wikipedia_tfa

(see above)

You can also provide a `name` for the twuckoo instance which appears in the notifications (if you do not provide a name explicitly, the name of the directory in which your twuckoo instance runs will get used):

    $ twuckoo -n pragthinklearn file

## Examples out there

In the course of the development of this gem I "ate my own dogfood" so you'll find at least one twitter account for each of the modules:

* [Pragmatic Thinking and Learning](http://twitter.com/pragthinklearn)

  An concise advice from the excellent [Pragmatic Thinking and Learning](http://pragprog.com/titles/ahptl/pragmatic-thinking-and-learning) book

* [Daily Oblique](http://twitter.com/daily_oblique)

  Serves you an [Oblique Strategy](http://www.rtqe.net/ObliqueStrategies/) per day.
  
* [Wikipedia Today's Featured Article](http://twitter.com/wikipedia_tfa)

  An interesting article from the English Wikipedia delivered right to your twitter feed.
  
If you set up something with twuckoo, I would like to know about it, so that I might include it here.

## Credits & License

This software is released under the MIT license (see attached). A link back to [this page](http://github.com/balinterdi/twuckoo/tree/master) would be appreciated if you release something based on it.

Any feedback (especially bug reports!) is highly appreciated, please report them [here](http://github.com/balinterdi/twuckoo/issues) or contact me at <balint@codigoergosum.com>

Original idea and development: [Balint Erdi](http://codigoergosum.com)
