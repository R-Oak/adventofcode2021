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

def read_chunks(str)
  while !str.empty? && chunk_open?(str[0])
    res, str = read_chunk(str)
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

total = 0
IO.readlines("input.txt").map { |line| line.strip }.each do |line|
  res, str = read_chunks(line)
  if res == false && !str.empty?
    total += score(str[0])
  end
end

print total, "\n"