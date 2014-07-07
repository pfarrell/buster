require 'json'

class Twitter::Entity::HashTag
  def to_json(opts={}) 
    return {text: text}.to_json
  end
end
