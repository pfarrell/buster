require 'json'
require 'timetrap'
require 'redis'

def output(method, dict, ctr)
  method.print "\n#{Time.now.to_s} calculating retweets from #{ctr} tweets [#{dict.count}]\n"
  dict.top(25).each do |tweet|
    method.print "#{tweet}\n"
  end
end

$r = Redis.new
ctr = 0
dict = TimeTrap.new

begin

  pubsub = Thread.new {
    $r.subscribe "tweets:raw" do |on|
      on.message do |channel, msg|
        next if msg.nil? || msg.size < 2
        tweet = JSON.parse(msg)
        next unless msg["lang"] = "en"
        ctr += 1
        dict.add(tweet["text"])
        output($stderr, dict, ctr) if(ctr % 500 == 0)
        #dict.delete_if {|key,val| val.count < 3 } if(ctr % 5000 == 0)
      end
    end
  }

  pubsub.join
rescue SignalException => ex
  puts ""
end
puts ctr
