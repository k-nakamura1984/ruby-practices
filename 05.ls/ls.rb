# frozen_string_literal: true

require 'optparse'
require 'etc'

# オプションを設定する
option = {}
OptionParser.new do |opt|
  opt.on('-a') { |v| option[:a] = v }
  opt.on('-l') { |v| option[:l] = v }
  opt.on('-r') { |v| option[:r] = v }
  opt.parse!(ARGV)
end

# カレントディレクトリの.以外のファイル名を取得する
lists = Dir.glob('*')
if option[:a]
  # aオプション .を含むファイル名もlistsに加える
  lists = Dir.glob('.*').reject { |x| x =~ /\.$/ } + Dir.glob('*')
end

if option[:r]
  # rオプション listsをreverseで逆順にする
  lists = lists.reverse
end

if option[:l]
  def mode_change(mode)
    {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }[mode]
  end

  def type_change(type)
    {
      'file' => '-',
      'directory' => 'd',
      'link' => 'l'
    }[type]
  end

  total = 0
  lists.each do |x|
    file = File::Stat.new(x) # File::Statを取得して、fileに代入する
    total += file.blocks
  end
  puts "total #{total}"

  lists.each do |x|
    file = File::Stat.new(x) # File::Statを取得して、fileに代入する
    file_type = type_change(file.ftype) # ファイルタイプ
    owner_mode = mode_change(file.mode.to_s(8).slice(-3, 1))
    group_mode = mode_change(file.mode.to_s(8).slice(-2, 1))
    other_mode = mode_change(file.mode.to_s(8).slice(-1, 1))
    file_link = file.nlink # リンク数
    owner_name = Etc.getpwuid(file.uid).name
    group_name = Etc.getgrgid(file.gid).name
    file_size = file.size # サイズ
    file_time = file.mtime.strftime('%m %d %R') # タイムスタンプ
    file_name = File.basename(x) # ファイル名
    print "#{file_type}#{owner_mode}#{group_mode}#{other_mode} #{file_link.to_s.rjust(2)} "
    print "#{owner_name} #{group_name} #{file_size.to_s.rjust(6)} #{file_time} #{file_name}\n"
  end
  return # lオプションの場合は3列表示しないので、ここまでの結果を出力する
end

# lオプションなし
# listsの要素数を3の倍数にするため、最後尾にnilを追加する
case lists.size % 3
when 1
  2.times { lists.push(nil) }
when 2
  lists.push(nil)
end

# listsをeach_sliceで、行数と同じ要素数の配列に分ける
sliced_lists = lists.each_slice(lists.size / 3).to_a

# slice_listsをtransposeで、行と列を入れ替える。flattenで一つの配列にする。
transposed_lists = sliced_lists.transpose.flatten

# transpose_listsをeach_with_indexで要素ごとに繰り返す
transposed_lists.each_with_index do |list, i|
  # 配列内の最長文字数に半角スペース2つ足した幅で、左寄せで表示する
  # print "#{list.to_s.ljust(transposed_lists.sort_by(&:length).last.length + 2)}"
  print list.to_s.ljust(22).to_s
  # 3列ごとに改行を入れて表示する
  print "\n" if ((i + 1) % 3).zero?
end
