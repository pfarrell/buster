require './lib/buster'
require 'json'


def broadcast(spy, tweet)
  puts tweet.to_json
end


#  $urls = "tweets:urls"
#  $raw = "tweets:raw"
#  $tagged = "tweets:tagged"

#  def broadcast(tweet)
#    json = tweet.to_json
#    @redis.publish($tweets, json)
#    @redis.publish($urls, json) if tweet.urls.size > 0
#    @redis.publish($tagged, json) if tweet.tags.size > 0
#    puts tweet
#  end

bus = Spy.new
bus.sample{|spy, tweet| broadcast(spy,tweet)}
