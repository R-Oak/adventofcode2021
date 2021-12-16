def hex_decode(str)
  decode = {
    '0' => '0000',
    '1' => '0001',
    '2' => '0010',
    '3' => '0011',
    '4' => '0100',
    '5' => '0101',
    '6' => '0110',
    '7' => '0111',
    '8' => '1000',
    '9' => '1001',
    'A' => '1010',
    'B' => '1011',
    'C' => '1100',
    'D' => '1101',
    'E' => '1110',
    'F' => '1111',
  }

  str.chars.map { |c| decode[c] }.join
end

def bin_to_int(str)
  result = 0
  str.chars.each do |c|
    result *= 2
    result += 1 if c == '1'
  end
  result
end

def decode_value(bits)
  result = 0
  while bits.length >= 5
    result *= 16
    result += bin_to_int(bits[1,4])
    if bits[0] == '0'
      bits = bits[5,bits.length]
      break
    end
    bits = bits[5,bits.length]
  end
  [result, bits]
end

def decode_operator(bits)
  if bits[0] == '0'
    len = bin_to_int(bits[1,15])
    bits = bits[16,bits.length]
    packets = decode_packets(bits[0,len])
    [packets, bits[len,bits.length]]
  else
    packets = []
    num_packets = bin_to_int(bits[1,11])
    bits = bits[12,bits.length]
    num_packets.times do |_|
      packet, bits = decode_packet(bits)
      packets += [packet]
    end
    [packets, bits]
  end
end

class Packet
  @@version_sum = 0
  def initialize(version)
    @version = version
    @@version_sum += version
  end

  def self.version_sum
    @@version_sum
  end
end

class LiteralPacket < Packet
  def initialize(version, value)
    super(version)
    @value = value
    # print "Literal: #{value}\n"
  end

  def value
    @value
  end
end

class SumPacket < Packet
  def initialize(version, packets)
    super(version)
    @packets = packets
  end

  def value
    @packets.map(&:value).sum
  end
end

class ProductPacket < Packet
  def initialize(version, packets)
    super(version)
    @packets = packets
  end

  def value
    result = 1
    @packets.each { |p| result *= p.value }
    result
  end
end

class MinPacket < Packet
  def initialize(version, packets)
    super(version)
    @packets = packets
  end

  def value
    @packets.map(&:value).min
  end
end

class MaxPacket < Packet
  def initialize(version, packets)
    super(version)
    @packets = packets
  end

  def value
    @packets.map(&:value).max
  end
end

class GreaterThanPacket < Packet
  def initialize(version, packets)
    super(version)
    @packets = packets
  end

  def value
    @packets[0].value > @packets[1].value ? 1 : 0
  end
end

class LessThanPacket < Packet
  def initialize(version, packets)
    super(version)
    @packets = packets
  end

  def value
    @packets[0].value < @packets[1].value ? 1 : 0
  end
end

class EqualPacket < Packet
  def initialize(version, packets)
    super(version)
    @packets = packets
  end

  def value
    @packets[0].value == @packets[1].value ? 1 : 0
  end
end

def decode_packet(bits)
  version = bin_to_int(bits[0,3])
  type = bin_to_int(bits[3,3])
  bits = bits[6,bits.length]

  # print "v:#{version} t:#{type}\n"

  case type
  when 0
    packets, bits = decode_operator(bits)
    packet = SumPacket.new(version, packets)
  when 1
    packets, bits = decode_operator(bits)
    packet = ProductPacket.new(version, packets)
  when 2
    packets, bits = decode_operator(bits)
    packet = MinPacket.new(version, packets)
  when 3
    packets, bits = decode_operator(bits)
    packet = MaxPacket.new(version, packets)
  when 4
    value, bits = decode_value(bits)
    packet = LiteralPacket.new(version, value)
  when 5
    packets, bits = decode_operator(bits)
    packet = GreaterThanPacket.new(version, packets)
  when 6
    packets, bits = decode_operator(bits)
    packet = LessThanPacket.new(version, packets)
  when 7
    packets, bits = decode_operator(bits)
    packet = EqualPacket.new(version, packets)
  else
    raise "Unknown type #{type}"
  end

  [packet, bits]
end

def decode_packets(bits)
  result = []
  while bits.length > 7
    packet, bits = decode_packet(bits)
    result += [packet]
  end
  result
end

bits = hex_decode(File.new("input.txt").readline.strip)
# print bits, "\n"

packet, bits = decode_packet(bits)
print packet.value, "\n"
