infile = File.new("input.txt")

polymer = infile.readline.strip
infile.readline  

rules = {}

while true
  begin
    pair, insert = infile.readline.strip.split(" -> ")
    rules[pair] = insert
  rescue => exception
    break
  end
end

step = 0

while step < 10
  step += 1
  polymer1 = polymer[0]
  polymer.length.times do |i|
    next if i == 0
    polymer1 += rules[polymer[i - 1] + polymer[i]]
    polymer1 += polymer[i]
  end
  polymer = polymer1
end

counts = {}
polymer.chars.each do |c|
  counts[c] = 0 unless counts.key?(c)
  counts[c] += 1
end

print counts, "\n"
print counts.values.max - counts.values.min, "\n"
