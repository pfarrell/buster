require 'json'

class Twitter::User
  def to_json(opts={})
    return {name: name, location: location, statuses_count: statuses_count, profile_image_uri: profile_image_uri}.to_json
  end
end
