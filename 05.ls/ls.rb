# frozen_string_literal: true

require 'optparse'
require 'etc'

option = {}
OptionParser.new do |option_parser|
  option_parser.on('-a') { |value| option[:a] = value }
  option_parser.on('-l') { |value| option[:l] = value }
  option_parser.on('-r') { |value| option[:r] = value }
  option_parser.parse!(ARGV)
end

files = Dir.glob('*')
files = Dir.glob('*', File::FNM_DOTMATCH) if option[:a]
files = files.reverse if option[:r]

CONVERSION_RULE = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def convert_octal_to_rwx(mode)
  CONVERSION_RULE[mode]
end

OMISSION_RULE = {
  'file' => '-',
  'directory' => 'd',
  'link' => 'l'
}.freeze

def omit_type(type)
  OMISSION_RULE[type]
end

if option[:l]
  total = files.sum do |file|
    File::Stat.new(file).blocks
  end
  puts "total #{total}"

  files.each do |file|
    file_stat = File::Stat.new(file)
    file_type = omit_type(file_stat.ftype)
    mode_octal = file_stat.mode.to_s(8)
    owner_mode = convert_octal_to_rwx(mode_octal.slice(-3, 1))
    group_mode = convert_octal_to_rwx(mode_octal.slice(-2, 1))
    other_mode = convert_octal_to_rwx(mode_octal.slice(-1, 1))
    file_link = file_stat.nlink
    owner_name = Etc.getpwuid(file_stat.uid).name
    group_name = Etc.getgrgid(file_stat.gid).name
    file_size = file_stat.size
    file_time = file_stat.mtime.strftime('%m %d %R')
    file_name = File.basename(file)
    print "#{file_type}#{owner_mode}#{group_mode}#{other_mode} #{file_link.to_s.rjust(2)} "
    print "#{owner_name} #{group_name} #{file_size.to_s.rjust(6)} #{file_time} #{file_name}\n"
  end

else
  INDICATION_LINE = 3
  longest_file_name = files.max_by(&:length)

  files.push('') while (files.size % INDICATION_LINE).positive?
  sliced_files = files.each_slice(files.size / INDICATION_LINE).to_a
  transposed_files = sliced_files.transpose

  transposed_files.each do |transposed_file|
    transposed_file.each do |file|
      print file.ljust(longest_file_name.length + 1)
    end
    puts
  end
end
