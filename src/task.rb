require_relative './values_creator'

$not_found = 'NOT_FOUND'

class Task
  attr_accessor :id
  attr_accessor :hash
  attr_accessor :pattern
  def initialize(_id, _hash, _pattern)
    @id = _id
    @hash = _hash
    @pattern = _pattern
    @values_creator = ValuesCreator.new(@pattern)
  end

  def marshal_dump
    [@id, @hash, @pattern]
  end

  def marshal_load(array)
    @id, @hash, @pattern = array
    @values_creator = ValuesCreator.new(@pattern)
  end

  def start
    # puts 'processing started'
    while @values_creator.has_next_value?
      current = @values_creator.current
      if is_searched_value?(current)
        puts '>> Found'
        return current
      end
      @values_creator.next
    end

    $not_found
  end

  def generate_next_patterns_array
    @values_creator.generate_next_patterns
  end

  def is_searched_value?(val)
    Digest::MD5.hexdigest(val) == hash
  end

end