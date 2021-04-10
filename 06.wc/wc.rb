# frozen_string_literal: true

require 'optparse'

option = {}
OptionParser.new do |option_parser|
  option_parser.on('-l') { |value| option[:l] = value }
  option_parser.parse!(ARGV)
end

def show_status_loption
  if ARGV.size.zero?
    input_lines = readlines.join.lines.size
    puts input_lines.to_s.rjust(8)
  else
    ARGV.each do |file_path|
      file_lines = File.read(file_path).lines.size
      file_name = File.basename(file_path)
      puts "#{file_lines.to_s.rjust(8)} #{file_name}"
    end
  end
end

def show_status
  if ARGV.size.zero?
    input = readlines.join
    input_lines = input.lines.size
    input_words = input.split(/\s+/).size
    input_byte_size = input.bytesize
    print "#{input_lines.to_s.rjust(8)} #{input_words.to_s.rjust(7)}"
    puts input_byte_size.to_s.rjust(8)
  else
    ARGV.each do |file_path|
      file = File.read(file_path)
      file_lines = file.lines.size
      file_words = file.split(/\s+/).size
      file_byte_size = file.bytesize
      file_name = File.basename(file_path)
      print "#{file_lines.to_s.rjust(8)} #{file_words.to_s.rjust(7)}"
      puts "#{file_byte_size.to_s.rjust(8)} #{file_name} "
    end
  end
end

def count_total
  $total_file_lines = 0
  $total_file_words = 0
  $total_file_byte_size = 0
  ARGV.each do |file_path|
    file = File.read(file_path)
    $total_file_lines += file.lines.size
    $total_file_words += file.split(/\s+/).size
    $total_file_byte_size += file.bytesize
  end
end

if option[:l]
  show_status_loption
else
  show_status
end

if ARGV.size > 1
  if option[:l]
    count_total
    puts "#{$total_file_lines.to_s.rjust(8)} total"
  else
    count_total
    print "#{$total_file_lines.to_s.rjust(8)} #{$total_file_words.to_s.rjust(7)}"
    puts "#{$total_file_byte_size.to_s.rjust(8)} total\n"
  end
end
