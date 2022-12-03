require 'csv'

inputs = []
CSV.foreach("./input.txt") do |row|
  inputs << row[0]
end

PRIORITY_QUEUE = ("a".."z").to_a + ("A".."Z").to_a

common_letters = []

inputs.each do |input|
  first_compartment, second_compartment = input.chars.each_slice(input.length / 2).map(&:join)
  common_letter = first_compartment.chars & second_compartment.chars
  raise StandardError.new "Can only be one error" if common_letter.length > 1

  common_letters << common_letter[0]
end

priorities_of_items = common_letters.reduce(0) do |accum,letter|
  accum += PRIORITY_QUEUE.index(letter) + 1
end

badge_priorities = inputs.each_slice(3).reduce(0) do |accum, (first_elf, second_elf, third_elf)|
  accum += PRIORITY_QUEUE.index((first_elf.chars & second_elf.chars & third_elf.chars)[0]) + 1
end

puts "Part A: #{priorities_of_items}"
puts "Part B: #{badge_priorities}"