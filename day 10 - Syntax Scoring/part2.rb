def chunk_open?(c)
  "(<{[".include?(c)
end

def closing(c)
  {
    '(' => ')',
    '<' => '>',
    '{' => '}',
    '[' => ']'
  }[c]
end

def read_chunk(str)
  closing = closing(str[0])
  str = str[1,str.length]
  
  while !str.empty?
    if chunk_open?(str[0])
      result, str = read_chunk(str)
      if result == false
        return false, str
      end
    elsif str[0] == closing
      return true, str[1,str.length]
    else
      return false, str
    end
  end

  # incomplete
  return false, ""
end

def complete_chunk(str)
  closing = closing(str[0])
  str = str[1,str.length]

  while !str.empty?
    if chunk_open?(str[0])
      result, str = complete_chunk(str)
      if result == false
        return false, str + closing
      end
    elsif str[0] == closing
      return true, str[1,str.length]
    else
      return false, ""
    end
  end

  # incomplete
  return false, closing
end

def read_chunks(str)
  while !str.empty? && chunk_open?(str[0])
    res, str = read_chunk(str)
    if res == false
      return false, str
    end
  end
  return true, ""
end

def complete_chunks(str)
  while !str.empty? && chunk_open?(str[0])
    res, str = complete_chunk(str)
    if res == false
      return false, str
    end
  end
  return true, ""
end

def score(c)
  {
    '>' => 25137,
    ')' => 3,
    '}' => 1197,
    ']' => 57
  }[c]
end

def complete_score(c)
  {
    '>' => 4,
    ')' => 1,
    '}' => 3,
    ']' => 2
  }[c]
end

def score_complete(str)
  result = 0
  while !str.empty?
    result *= 5
    result += complete_score(str[0])
    str = str[1,str.length]
  end
  result
end

incomplete = IO.readlines("input.txt").map { |line| line.strip }.select do |line|
  res, str = read_chunks(line)
  str.empty?
end

scores = incomplete.map do |line|
  res, str = complete_chunks(line)
  score_complete(str)
end.sort

print scores[scores.length / 2], "\n"