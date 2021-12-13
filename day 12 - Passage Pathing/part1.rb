caves = {}

(IO.readlines("input.txt").map { |line| line.strip }).each do |line|
  c1, c2 = line.split("-")
  caves[c1] = [] unless caves.key?(c1)
  caves[c1] += [c2]  
  caves[c2] = [] unless caves.key?(c2)
  caves[c2] += [c1]  
end

# print caves, "\n"

worklist = [["start"]]
result = []
while !worklist.empty?
  # print worklist, "\n"
  path = worklist.shift
  # print path[-1], "\n"
  if path[-1] == "end"
    result += [path]
  else
    caves[path[-1]].each do |nxt|
      if nxt == nxt.upcase || !path.include?(nxt)
        worklist += [path + [nxt]]
      end
    end
  end
end

# print result, "\n"
print result.length, "\n"
