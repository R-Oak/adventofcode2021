infile = File.new("input.txt")

template = infile.readline.strip
infile.readline

rules = {}

while true
  begin
    pair, insert = infile.readline.strip.split(" -> ")
    rules[pair] = [pair[0] + insert, insert + pair[1]]
  rescue => exception
    break
  end
end

polymer = {}

(template.length-1).times do |i|
  pair = template[i,2]
  polymer[pair] = 0 unless polymer.key?(pair)
  polymer[pair] += 1
end

print polymer, "\n"

step = 0

while step < 40
  step += 1
  polymer1 = {}
  polymer.each do |pair, count|
    rules[pair].each do |pair1|
      polymer1[pair1] = 0 unless polymer1.key?(pair1)
      polymer1[pair1] += count
    end
  end
  polymer = polymer1
end

print polymer, "\n"

counts = {}
polymer.each do |pair, count|
  counts[pair[0]] = 0 unless counts.key?(pair[0])
  counts[pair[0]] += count
  counts[pair[1]] = 0 unless counts.key?(pair[1])
  counts[pair[1]] += count
end

result = {}
counts.each do |c, count|
  result[c] = count / 2
end

result[template[0]] += 1
result[template[-1]] += 1 unless template[0] == template[-1]

print result, "\n"
print result.values.max - result.values.min, "\n"
