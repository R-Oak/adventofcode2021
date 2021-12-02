commands = IO.readlines("input.txt").map { |line| line.strip }

pos = 0
depth = 0

commands.each do |command|
  cmd, n = command.split
  num = n.to_i
  if cmd == 'forward'
    pos += num
  elsif cmd == 'down'
    depth += num
  elsif cmd == 'up'
    depth -= num
  else
    print "Unknown command #{cmd}"    
  end
end

print pos * depth
