# frozen_string_literal: true

require 'optparse'

option = {}
OptionParser.new do |option_parser|
  option_parser.on('-l') { |value| option[:l] = value }
  option_parser.parse!(ARGV)
end

if ARGV.size.zero?
  input = readlines.join
  input_lines = input.lines.size
  input_words = input.split(/\s+/).size
  input_byte_size = input.to_s.bytesize
  if option[:l]
    print input_lines.to_s.rjust(8).to_s
  else
    print "#{input_lines.to_s.rjust(8)} #{input_words.to_s.rjust(7)}"
    print input_byte_size.to_s.rjust(8).to_s
  end
  puts
end

total_file_lines = 0
total_file_words = 0
total_file_byte_size = 0
if option[:l]
  ARGV.each_index do |index|
    file = File.read(ARGV[index])
    file_lines = file.lines.size
    total_file_lines += file.lines.size
    file_name = File.basename(ARGV[index])
    print "#{file_lines.to_s.rjust(8)} #{file_name}"
    puts
  end
  if ARGV.size > 1
    print "#{total_file_lines.to_s.rjust(8)} total"
    puts
  end
else
  ARGV.each_index do |index|
    file = File.read(ARGV[index])
    file_lines = file.lines.size
    total_file_lines += file.lines.size
    file_words = file.split(/\s+/).size
    total_file_words += file.split(/\s+/).size
    file_byte_size = file.to_s.bytesize
    total_file_byte_size += file.to_s.bytesize
    file_name = File.basename(ARGV[index])
    print "#{file_lines.to_s.rjust(8)} #{file_words.to_s.rjust(7)}"
    print "#{file_byte_size.to_s.rjust(8)} #{file_name} "
    puts
  end
  if ARGV.size > 1
    print "#{total_file_lines.to_s.rjust(8)} #{total_file_words.to_s.rjust(7)}"
    print "#{total_file_byte_size.to_s.rjust(8)} total"
    puts
  end
end
