inputs = []
File.open("./input.txt").each do |line|
  inputs << line.chomp
end

trees_map = {}
NUMBER_OF_ROWS = inputs.length
NUMBER_OF_COLS = inputs[0].length

class Tree
  attr_reader :row, :col, :height
  def initialize(row, col, height)
    @row = row
    @col = col
    @height = height
  end
end

def visible?(tree, direction, target_tree_height, trees_map)
  return false if target_tree_height <= tree.height
  
  delta_row, delta_col = direction

  return true if tree.row === 0 && delta_row === -1
  return true if tree.row === NUMBER_OF_ROWS - 1 && delta_row === 1
  return true if tree.col === 0 && delta_col === -1
  return true if tree.col === NUMBER_OF_COLS - 1 && delta_col === 1

  visible?(trees_map["#{tree.row + delta_row}_#{tree.col + delta_col}"], direction, target_tree_height, trees_map)
end

def visible_from_outside?(tree, trees_map)
  return true if tree.row == 0 || tree.row == NUMBER_OF_COLS - 1
  return true if tree.col == 0 || tree.col == NUMBER_OF_ROWS - 1

  visible?(trees_map["#{tree.row - 1}_#{tree.col}"], [-1, 0], tree.height, trees_map) || 
    visible?(trees_map["#{tree.row + 1}_#{tree.col}"], [1, 0], tree.height, trees_map) ||
    visible?(trees_map["#{tree.row}_#{tree.col - 1}"], [0, -1], tree.height, trees_map) ||
    visible?(trees_map["#{tree.row}_#{tree.col + 1}"], [0, 1], tree.height, trees_map)
end

def points(tree, direction, tree_height, count, trees_map)
  return count if !tree

  delta_row, delta_col = direction

  tree.height < tree_height ? points(trees_map["#{tree.row + delta_row}_#{tree.col + delta_col}"], direction, tree_height, count + 1, trees_map) : count + 1
end

def total_scenic_points(tree, trees_map)
  points(trees_map["#{tree.row - 1}_#{tree.col}"], [-1, 0], tree.height, 0, trees_map) * 
    points(trees_map["#{tree.row + 1}_#{tree.col}"], [1, 0], tree.height, 0, trees_map) *
    points(trees_map["#{tree.row}_#{tree.col - 1}"], [0, -1], tree.height, 0, trees_map) *
    points(trees_map["#{tree.row}_#{tree.col + 1}"], [0, 1], tree.height, 0, trees_map)
end

inputs.each_with_index do |input, idx|
  input.chars.each_with_index do |tree_height, jdx|
    # compound key of row_col
    trees_map["#{idx}_#{jdx}"] = Tree.new(idx, jdx, tree_height)
  end
end


visible_trees = trees_map.values.reduce(0)  do |accum, tree|
  accum += 1 if visible_from_outside?(tree, trees_map)
  accum
end

scenic_points = trees_map.values.map do |tree|
  total_scenic_points(tree, trees_map)
end.max

p "Part A: #{visible_trees}"
p "Part B: #{scenic_points}"

