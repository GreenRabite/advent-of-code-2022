inputs = []
File.open("./dummy.txt").each do |line|
  inputs << line.chomp
end

  $monkeys = []


ROUNDS_NEEDED = 10000
RELIEF_LEVEL = 96577

class Monkey
  attr_accessor :items, :position, :count
  attr_reader :modulo_test, :operation, :true_test, :false_test
  def initialize(starting_items, position, modulo_test, operation, true_test, false_test)
    @items = starting_items
    @position = position
    @modulo_test = modulo_test
    @operation = operation
    @true_test = true_test
    @false_test = false_test
    @count = 0
  end

  def finish_round
    inspect_items
    get_bored
    test_items
  end

  def inspect_items
    items.each do |item|
      inspect_item(item)
    end
  end

  def inspect_item(item)
    cmds = @operation.split("=")[-1].strip.split(" ")
    objects = []
    arithmetic_operation = ''
    cmds.each do |cmd|
      if cmd === 'old'
        objects << item.worry
      elsif cmd.to_i > 0
        objects << cmd.to_i
      elsif cmd.match(/[\+\-\*]/)
        arithmetic_operation = cmd
      end
    end


    new_worry = objects.reduce(nil) do |accum, object|
      if accum.nil?
        accum = object
      else
        accum = accum.send(arithmetic_operation,object) 
      end
      accum
    end
    item.worry = new_worry
    self.count += 1
  end

  def get_bored
    @items.each do |item|
      item.worry = item.worry /  RELIEF_LEVEL
      # item.worry = item.worry
    end
  end

  def add_item(item)
    @items << item
  end

  def test_items
    @items.each do |item|
      if item.worry % modulo_test === 0
        throw_item(item, true_test)
      else
        throw_item(item, false_test)
      end
    end

    @items = []
  end

  def throw_item(item, position)
    ($monkeys.find {|monkey| monkey.position === position}).add_item(item)
  end
end

class Item
  attr_accessor :worry
  def initialize(worry)
    @worry = worry
  end
end

idx = 0

while idx < inputs.length
  command = inputs[idx]
  if command.match(/Monkey/)
    position = inputs[idx].gsub(/[^0-9]/, '').to_i
    items = inputs[idx + 1].split(":")[-1].split(",").map(&:to_i)
    operation = inputs[idx + 2].split(":")[-1].strip
    modulo_test = inputs[idx + 3].gsub(/[^0-9]/, '').to_i
    true_test = inputs[idx + 4].gsub(/[^0-9]/, '').to_i
    false_test = inputs[idx + 5].gsub(/[^0-9]/, '').to_i

    starting_items = items.map {|item| Item.new(item)}
    $monkeys << Monkey.new(starting_items, position, modulo_test, operation, true_test, false_test)
    
    idx += 4
  end
  idx+=1
end

ROUNDS_TARGET = [1,20,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000]

ROUNDS_NEEDED.times do |t|
  $monkeys.each {|monkey| monkey.finish_round}
end

# p $monkeys.map {|m| m.modulo_test }.reduce(1) {|acc,n| acc.lcm(n)}
p "Part: #{$monkeys.map {|monkey| monkey.count}.sort.reverse.first(2).reduce(1) {|accum,m| accum *= m}}"
