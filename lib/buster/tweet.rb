require 'twitter'
require 'json'

class Twitter::Tweet

  def to_json(opts={})
    ret = {
            id: id, 
            text: text, 
            date: created_at, 
            favorites: favorite_count,
            retweets: retweet_count,
            hashtags: hashtags.map{|hashtag| hashtag.text}.to_json(opts),
            user: user.to_json(opts)
          }.to_json(opts)
  end
end  
