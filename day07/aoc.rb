inputs = []
File.open("./input.txt").each do |line|
  inputs << line.chomp
end

directories = {}
$memo_size = {}
current_dir = nil
FILE_SYSTEM_SIZE = 70000000
MIN_SPACE_NEEDED = 30000000


class Directory
  attr_reader :parent, :size, :files, :directories, :name
  def initialize(name='/', parent=nil)
    @name=name
    @size
    @directories=[]
    @files=[]
    @parent=parent
  end

  def add_directory(directory)
    @directories << directory
  end

  def add_file(name, size)
    @files << ElfFile.new(name,size)
  end

  def size
    $memo_size[name] ||= get_size
  end

  def get_size
    @files.reduce(0) {|accum,file| accum += file.size} + directories.reduce(0) {|accum, directory| accum += directory.size}
  end
end

class ElfFile
  attr_reader :name, :size
  def initialize(name, size)
    @name=name
    @size=size
  end
end

def current_path(directory)
  return '' if !directory
  return '/' if directory.parent.nil?

  current_path(directory.parent) +'/' + directory.name
end

command_inputs = inputs.reduce([]) do |accum, cmd|
  if cmd.match(/^\$ ls$/)
    accum << {cmd: cmd, list: []}
  elsif cmd.match(/^dir [a-z]+/) || cmd.match(/^\d+ \w+.?/)
    accum[-1]['list'.to_sym] << cmd
  else
    accum << {cmd: cmd}
  end

  accum
end

command_inputs.each do |input|
  _, command, param = input[:cmd].split(" ")

  if command === 'cd'
    if param === '..'
      current_dir = current_dir.parent
    else
      name = current_path(current_dir) + param
      directories[name] ||= Directory.new(name, current_dir)
      current_dir = directories[name]
    end
  elsif command === 'ls'
    input[:list].each do |file_or_directory|
      if file_or_directory.match(/^dir/)
        _, directory_name = file_or_directory.split(' ')
        name = current_path(current_dir) + directory_name
        directories[name] ||= Directory.new(name, current_dir)
        current_dir.add_directory(directories[name])
      end

      if file_or_directory.match(/^\d+ \w+.?/)
        size, name = file_or_directory.split(' ')
        current_dir.add_file(name, size.to_i)
      end
    end
  end
end


p "Part A: #{directories.values.filter {|directory| directory.size <= 100000}.reduce(0) {|accum,d| accum += d.size}}"
p "Part B: #{$memo_size.values.sort.select {|x| x >= MIN_SPACE_NEEDED - (FILE_SYSTEM_SIZE - $memo_size.values.max) }[0]}"