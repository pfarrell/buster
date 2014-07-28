require './lib/buster'
require 'redis'
require 'json'

$connected = ARGV[0] != "offline"
$redis = Redis.new
$urls = "tweets:urls"
$raw = "tweets:raw"
$tagged = "tweets:tagged"

def broadcast(spy, tweet)
  print "."
  json = tweet.to_json
  $redis.publish($raw, json)
  $redis.publish($urls, json) if json["urls"] && json["urls"].size > 0
  $redis.publish($tagged, json) if json["hashtags"] && json["hashtags"].size > 0
end

bus = $connected ? Spy.new : SpyMock.new("spec/fixtures/tweets_redacted.json")

bus.sample{|spy, tweet| broadcast(spy,tweet)}
