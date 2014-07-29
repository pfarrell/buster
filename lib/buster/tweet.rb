require 'twitter'
require 'json'

class Twitter::Tweet

  def to_json(opts={})
    ret = {
            id: id, 
            lang: lang,
            text: text, 
            date: created_at, 
            favorites: favorite_count,
            retweets: retweet_count,
            hashtags: hashtags.map{|hashtag| hashtag.text}
            user: user
          }.to_json(opts)
  end
end  
