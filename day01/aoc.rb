require 'csv'

inputs = []
CSV.foreach("./input.txt") do |row|
  inputs << row[0]
end

most_calories = 0
elves_calories = []

inputs.reduce(0) do |accum, input|
  if input
    accum += input.to_i
  else
    most_calories = accum if accum > most_calories
    elves_calories << accum
    accum = 0
  end

  accum
end

puts "Part A: #{most_calories}"

puts "Part B: #{elves_calories.sort.reverse.first(3).reduce(:+)}"