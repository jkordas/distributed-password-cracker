require_relative './config'

class ValuesCreator
  attr_accessor :current

  def initialize(pattern)
    @possible_characters = Array('a'..'z')
    @pattern = pattern
    @last_value = generate_last_value
    @current = generate_first_value
  end

  def generate_last_value
    str = String.new('')
    @pattern.each_char { |character|
      if character == '*'
        str += @possible_characters.last
      else
        str += character
      end
    }
    str
  end

  def generate_first_value
    str = String.new('')
    @pattern.each_char { |character|
      if character == '*'
        str += @possible_characters.first
      else
        str += character
      end
    }
    str
  end

  def has_next_value?
    @current != @last_value
  end

  def next
    reversed = @current.reverse
    if !has_next_value?
      raise Exception, 'Cannot generate (next value does not exist)'
    end

    (0..reversed.length - 1).each do |i|
      if reversed[i] != @possible_characters.last
        index = @possible_characters.index(reversed[i])
        reversed[i] = @possible_characters.at(index + 1)
        (0..i - 1).each { |j|
          reversed[j] = @possible_characters.first
        }
        break
      end
    end

    @current = reversed.reverse
  end

  def generate_next_patterns
    if @pattern.length == Conf::MAX_LENGTH
      return []
    end

    pat = @pattern
    replaced = false
    for i in 0..pat.length - 1
      if pat[i] == '*' and !replaced
        pat[i] = '_'
        replaced = true
      end
    end
    pat += '*'

    patterns = []
    (0..@possible_characters.length - 1).each do |j|
      cur = pat + ''
      (0..pat.length - 1).each do |i|
        if pat[i] == '_'
          cur[i] = @possible_characters[j]
        end
      end
      patterns.push(cur)
    end
    patterns
  end
end


