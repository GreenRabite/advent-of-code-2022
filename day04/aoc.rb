require 'csv'

inputs = []
File.open("./input.txt").each do |line|
  inputs << line.chomp
end

numbers_contained = inputs.reduce(0) do |accum, input|
  elf_1_containers, elf_2_containers = input.split(',')
  elf_1_min, elf_1_max = elf_1_containers.split('-').map(&:to_i)
  elf_2_min, elf_2_max = elf_2_containers.split('-').map(&:to_i)
  is_contain = (elf_1_min >= elf_2_min && elf_2_max >= elf_1_max) || (elf_2_min >= elf_1_min && elf_1_max >= elf_2_max)
  accum +=1 if is_contain
  accum
end

numbers_overlapped = inputs.reduce(0) do |accum, input|
  elf_1_containers, elf_2_containers = input.split(',')
  elf_1_min, elf_1_max = elf_1_containers.split('-').map(&:to_i)
  elf_2_min, elf_2_max = elf_2_containers.split('-').map(&:to_i)
  is_overlap = (elf_1_max >= elf_2_min && elf_2_max >= elf_1_min ) || (elf_2_max >= elf_1_min && elf_1_max >= elf_2_min )
  accum +=1 if is_overlap
  accum
end

puts "Part A: #{numbers_contained}"
puts "Part B: #{numbers_overlapped}"