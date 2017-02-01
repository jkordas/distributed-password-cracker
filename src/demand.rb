
class Demand
  attr_accessor :client
  attr_accessor :result
  attr_accessor :counter

  def initialize(_client)
    @client = _client
    @result = false
    @counter = 0
  end
end