# frozen_string_literal: true

require 'optparse'

option = {}
OptionParser.new do |option_parser|
  option_parser.on('-l') { |value| option[:l] = value }
  option_parser.parse!(ARGV)
end

def show_status_loption
  width = 8
  if ARGV.size.zero?
    input = readlines.join
    puts input.lines.size.to_s.rjust(width)
  else
    ARGV.each do |file_path|
      file_lines = File.read(file_path).lines.size
      print file_lines.to_s.rjust(width)
      puts " #{File.basename(file_path)}"
    end
    puts "#{ARGV.sum { |file_path| File.read(file_path).lines.size }.to_s.rjust(width)} total" if ARGV.size > 1
  end
end

def show_status
  width = 8
  if ARGV.size.zero?
    input = readlines.join
    print input.lines.size.to_s.rjust(width)
    print input.split(/\s+/).size.to_s.rjust(width)
    puts input.bytesize.to_s.rjust(width)
  else
    ARGV.each do |file_path|
      file = File.read(file_path)
      print file.lines.size.to_s.rjust(width)
      print file.split(/\s+/).size.to_s.rjust(width)
      print file.bytesize.to_s.rjust(width)
      puts  " #{File.basename(file_path)} "
    end
    if ARGV.size > 1
      print ARGV.sum { |file_path| File.read(file_path).lines.size }.to_s.rjust(width)
      print ARGV.sum { |file_path| File.read(file_path).split(/\s+/).size }.to_s.rjust(width)
      puts "#{ARGV.sum { |file_path| File.read(file_path).bytesize }.to_s.rjust(width)} total"
    end
  end
end

if option[:l]
  show_status_loption
else
  show_status
end
