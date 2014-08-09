class Connection
  attr_accessor :conn, :pattern

  def initialize(conn, opt={})
    @conn = conn
    @pattern = opt[:pattern]
  end
end

