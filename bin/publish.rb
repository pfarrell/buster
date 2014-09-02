require './lib/buster'
require 'redis'
require 'json'

$connected = ARGV[0] != "offline"
$redis = Redis.new
$urls = "tweets:urls"
$raw = "tweets:raw"
$tagged = "tweets:tagged"

def generate_pid(file_name, process_id)
  File.open(file_name, 'w+') {|f| f.write($$) }
end

def running?(file_name)
  retval = true
  if !File.exists?(file_name)
    generate_pid(file_name, $$)
    retval = false
  else
    file_pid = open(file_name).gets
    begin
      Process.kill 0, file_pid.to_i
    rescue
      generate_pid(file_name, $$)
      retval = false
    end
  end
  retval
end

def broadcast(spy, tweet)
  json = tweet.to_json
  $redis.publish($raw, json)
  $redis.publish($urls, json) if json["urls"] && json["urls"].size > 0
  $redis.publish($tagged, json) if json["hashtags"] && json["hashtags"].size > 0
end

unless running?("/tmp/buster.pid")
  bus = $connected ? Spy.new : SpyMock.new("spec/fixtures/tweets_redacted.json")
  bus.sample{|spy, tweet| broadcast(spy,tweet)}
end
