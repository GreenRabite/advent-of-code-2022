inputs = []
File.open("./input.txt").each do |line|
  inputs << line.chomp
end

results = []
queue = []
crt_image = []
x = 1

inputs.each_with_index do |input, idx|
  x += queue.pop if queue.length > 0
  if input === 'noop'
    symbol = (x-1..x+1).cover?(results.length % 40) ? '#' : '.'
    crt_image << symbol
    results << x
    next
  end
  if input.match(/addx/)
    _, value = input.split(" ").map(&:to_i)
    queue << value
    2.times do
      symbol = (x-1..x+1).cover?(results.length % 40) ? '#' : ' '
      crt_image << symbol
      results << x
    end
  end
end

CYCLES_TO_SUM = [20, 60, 100, 140, 180, 220]

p "Part A: #{CYCLES_TO_SUM.reduce(0) {|accum,cycles| accum += results[cycles -1] * cycles}}"
crt_image.each_slice(40) do |slice|
  p slice.join
end