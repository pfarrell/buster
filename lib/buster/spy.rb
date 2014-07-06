require 'twitter'

class Spy
  attr_accessor :spy, :count

  def initialize
    @count = 0
    @spy = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = ENV["BUSTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["BUSTER_CONSUMER_SECRET"]
      config.access_token        = ENV["BUSTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["BUSTER_ACCESS_TOKEN_SECRET"]
    end
  end

  def handle(tweet, &block)
    @count += 1
    case tweet
      when Twitter::Tweet
        block.call(self, tweet)
    end
  end

  def sample(&block)
    @spy.sample {|object| handle(object, &block) }
  end

  def filter(keywords, &block)
    @spy.filter(track: keywords){|object| handle(object, &block) }
  end

end
