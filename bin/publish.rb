require './lib/buster'
require 'redis'
require 'json'

$redis = Redis.new
$urls = "tweets:urls"
$raw = "tweets:raw"
$tagged = "tweets:tagged"

def broadcast(spy, tweet)
  json = tweet.to_json
  puts json
  $redis.publish($tweets, json)
  $redis.publish($urls, json) if tweet.urls.size > 0
  $redis.publish($tagged, json) if tweet.hashtags.size > 0
end

bus = Spy.new
bus.sample{|spy, tweet| broadcast(spy,tweet)}
