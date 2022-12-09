inputs = []
File.open("./input.txt").each do |line|
  inputs << line.chomp
end


ROPE = Array.new(2) { Array.new(2,0) }
LONG_ROPE = Array.new(10) { Array.new(2,0) }


class Point
  attr_reader :x, :y
  def initialize(x,y)
    @x=x
    @y=y
  end
end

def move_head(current_position, direction)
  x, y = current_position
  if direction === 'R'
    head = [x + 1, y]
  elsif direction === 'L'
    head = [x - 1, y]
  elsif direction === 'U'
    head = [x, y + 1]
  elsif direction === 'D'
    head = [x, y - 1]
  end
  head
end

def move_tail(current_position, head)
  x,y = current_position
  head_x, head_y = head
  slope_y = head_y - y
  slope_x = head_x - x
  if slope_y === 0
    tail = [x + (slope_x > 0 ? 1 : -1), y]
  elsif slope_x === 0
    tail = [x, y + (slope_y > 0 ? 1 : -1)]
  else
    tail = [x + (slope_x > 0 ? 1 : -1), y + (slope_y > 0 ? 1 : -1)]
  end
  tail
end

def is_adjacent?(head, tail)
  (head[0] - tail[0]).abs <= 1 && (head[1] - tail[1]).abs <= 1
end

[ROPE, LONG_ROPE].each do |rope|
  tail_visited = [[0,0]]

  inputs.each do |input|
    direction, step = input.split(" ")
    step.to_i.times do
      rope.each_cons(2).with_index do |(head, tail), idx|
        rope[idx] = move_head(head, direction) if idx === 0
        rope[idx + 1] = move_tail(tail, rope[idx]) unless is_adjacent?(rope[idx],tail)
        tail_visited << rope[idx + 1] if (rope.length === idx + 2)
      end
    end
  end
  p "Part #{rope === ROPE ? 'A' : 'B'}: #{tail_visited.uniq.count}"
end
