require 'json'
class SpyMock
  attr_accessor :tweets

  def initialize(fixture_path)
    @tweets = []
    File.new(fixture_path).each_line do |line|
      @tweets << JSON.parse(line)
    end
  end

  def sample(&block)
    while(true) do
    @tweets.each {|tweet| block.call(self, tweet)}
    end
  end
    
end
