require 'sinatra'
require 'sinatra/streaming'
require 'redis'
require 'json'
require 'haml'
require 'byebug'

class Windowing < Sinatra::Base
  helpers Sinatra::Streaming
  set connections: [], r: Redis.new
  set :server, :thin
  use Rack::Deflater

  before do
    cache_control :no_cache
  end

  get '/' do
    redirect '/index.html'
  end

  get '/tweet_stream', provides: 'text/event-stream' do
    stream :keep_open do |out|
      content_type "text/event-stream"
      settings.connections << out
      puts "added connection"
      out.callback { 
        puts "removed connection"
        settings.connections.delete(out) 
      }
      settings.r.subscribe "tweets:raw" do |on|
        on.message do |channel, msg|
          settings.connections.each do |out|
            out.puts("data: #{{time: Time.now, channel: channel, message: msg}.to_json}\n\n") unless out.closed
          end
        end
      end
    end
  end
end
