require 'sinatra'
require 'sinatra/streaming'
require 'sinatra/url_for'
require 'redis'
require 'json'
require 'haml'
require 'byebug'
require './lib/buster'


class Windowing < Sinatra::Base
  helpers Sinatra::UrlForHelper
  helpers Sinatra::Streaming
  set connections: [], r: Redis.new
  set :server, :thin
  use Rack::Deflater

  before do
    cache_control :no_cache
  end

  get '/' do
    haml :index
  end

  get '/collage' do
    haml :collage
  end

  get '/stats' do
    haml :stats
  end

  get '/tweet_stream', provides: 'text/event-stream' do
    stream :keep_open do |out|
      content_type "text/event-stream"
      conn = Connection.new(out, pattern: params)
      settings.connections << conn
      out.callback { 
        puts "removed connection"
        settings.connections.delete(out) 
      }
      settings.r.subscribe "tweets:raw" do |on|
        on.message do |channel, msg|
          raw = JSON.parse(msg)
          settings.connections.each do |connection|
            connection.conn.puts("data: #{{time: Time.now, channel: channel, message: raw}.to_json}\n\n") if !connection.conn.closed
          end
        end
      end
    end
  end
end
