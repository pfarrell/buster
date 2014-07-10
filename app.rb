require 'sinatra'
require 'sinatra/streaming'
require 'redis'
require 'json'
require 'haml'

class Windowing < Sinatra::Base
  helpers Sinatra::Streaming
  set connections: [], r: Redis.new


  get '/tweet_stream', provides: 'text/event-stream' do
    puts settings.connections.count
    stream :keep_open do |out|
      settings.connections << out
      puts settings.connections.count
      out.callback { settings.connections.delete(out) }

      settings.r.subscribe "tweets:raw" do |on|
        on.message do |channel, msg|
          settings.connections.each do |out|
            out.puts({time: Time.now, channel: channel, message: msg}.to_json + "\n\n")
          end
        end
      end
    end
  end
end
