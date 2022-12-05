require 'csv'

inputs = []
File.open("./input.txt").each do |line|
  inputs << line.chomp
end

class Column
  attr_reader :stack
  def initialize
    @stack = []
  end

  def insert(crate)
    @stack.unshift(crate)
  end

  def remove
    @stack.pop
  end

  def mult_remove(num_of_crates)
    @stack.pop(num_of_crates)
  end

  def add(crate)
    @stack.push(crate)
  end

  def mult_add(crates)
    @stack += crates
  end

  def top_crate
     @stack[-1]
  end
end

# Set Up Columns
crate_columns = Array.new(9) {|col| Column.new}
second_crate_columns = Array.new(9) {|col| Column.new}

# Fill up columns to initial position
inputs.first(8).each_with_index do |input, idx|
  input.chars.each_slice(4).each_with_index do |rows, column_idx|
    crate_value = rows[1].strip.chomp
    next if crate_value.empty?

    crate_column = crate_columns[column_idx]
    crate_column.insert(crate_value)

    second_crate_column = second_crate_columns[column_idx]
    second_crate_column.insert(crate_value)
  end
end

# Input directions
inputs.drop(10).each do |line_of_direction|
  # e.g. move 2 from 4 to 6
  # gsub to 246
  # where 1st index is # of crate, 2 is where we removing it from, and 3rd is where it being inserted to
  directions = line_of_direction.gsub(/[^0-9]/, '').chars
  # TODO: better way to do this?
  if directions.length === 3
    num_of_crates, from_column, to_column = directions.map(&:to_i)
  else
    num_of_crates, from_column, to_column = [directions.first(2).join("").to_i,directions[2].to_i, directions[3].to_i ]
  end

  raise StandardError.new("Not enough crates") if crate_columns[from_column - 1].stack.length < num_of_crates
  num_of_crates.times do 
    removed_crate_value = crate_columns[from_column - 1].remove
    crate_columns[to_column - 1].add(removed_crate_value)
  end

  removed_crate_values = []
  raise StandardError.new("Not enough crates") if second_crate_columns[from_column - 1].stack.length < num_of_crates

  removed_crate_values = second_crate_columns[from_column - 1].mult_remove(num_of_crates)
  second_crate_columns[to_column - 1].mult_add(removed_crate_values)
end

p "Part A: #{crate_columns.map {|column| column.top_crate}.join("")}"
p "Part B: #{second_crate_columns.map {|column| column.top_crate}.join("")}"