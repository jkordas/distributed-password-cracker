class Result
  attr_accessor :id
  attr_accessor :hash
  attr_accessor :result
  def initialize(_id, _hash, _result)
    @id = _id
    @hash = _hash
    @result = _result
  end
end