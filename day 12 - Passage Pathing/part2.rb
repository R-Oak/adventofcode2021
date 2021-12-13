caves = {}

(IO.readlines("input.txt").map { |line| line.strip }).each do |line|
  c1, c2 = line.split("-")
  caves[c1] = [] unless caves.key?(c1)
  caves[c1] += [c2]  
  caves[c2] = [] unless caves.key?(c2)
  caves[c2] += [c1]  
end

# print caves, "\n"

def is_upper?(str)
  str == str.upcase
end

def can_visit?(path, cave)
  return false if cave == 'start'
  return true if is_upper?(cave)

  visited = {}
  path.each do |c|
    unless is_upper?(c)
      visited[c] = 0 unless visited.key?(c)
      visited[c] += 1
    end
  end

  return true unless visited.key?(cave)

  return false if visited.each_value.any? { |val| val > 1 }
  true 
end

worklist = [["start"]]
result = 0
while !worklist.empty?
  # print worklist, "\n"
  path = worklist.shift
  # print path[-1], "\n"
  if path[-1] == "end"
    result += 1
  else
    caves[path[-1]].each do |nxt|
      if can_visit?(path, nxt)
        # print path + [nxt], "\n"
        worklist += [path + [nxt]]
      end
    end
  end
end

# print result, "\n"
print result, "\n"
