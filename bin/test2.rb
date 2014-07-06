require './lib/buster'
require 'json'


def broadcast(spy, tweet)
  puts tweet.text
end

bus = Spy.new
bus.filter("worldcup"){|spy, tweet| broadcast(spy,tweet)}
