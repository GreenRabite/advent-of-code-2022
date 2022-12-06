input = ""
File.open("./input.txt").each do |line|
  input << line.chomp
end

substream = input.chars
PACKET_MARKER = 4
MESSAGE_MARKER = 14

[PACKET_MARKER, MESSAGE_MARKER].each do |limit|
  idx = 0
  markers = []
  while true
    markers << substream[idx]
    if markers.length > limit
      markers.shift
    end
  
    if markers.length == limit && markers.uniq.length == limit
      p "Part #{limit == PACKET_MARKER ? 'A' : 'B'}: #{idx + 1}"
      break
    end
    idx += 1
  end
end
