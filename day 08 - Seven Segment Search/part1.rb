total = 0

IO.readlines("input.txt").map { |line| line.strip }.each do |line|
  input, output = line.split(" | ")
  output.split(" ").each do |val|
    if val.length == 2 || val.length == 3 || val.length == 4 || val.length == 7
      total += 1
    end
  end
end

print total, "\n"
