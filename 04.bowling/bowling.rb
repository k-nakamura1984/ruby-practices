#!/usr/bin/env ruby
# frozen_string_literal: true

scores = ARGV[0].split(',')

shots = []
scores.each do |score|
  case score
  when 'X'
    shots << 10
    shots << 0
  else
    shots << score.to_i
  end
end

frames = shots.each_slice(2).to_a

frames.each_with_index do |frame, i|
  if frame[0] == 10
    frames[i].clear
    frames[i] << 10
  end
end

case frames.length
when 11
  frames[10].each { |f| frames[9] << f }
  frames.delete_at(10)
when 12
  frames[9].push(frames[10][0])
  frames[9].push(frames[11][0])
  2.times { frames.delete_at(10) }
end

point = frames.each_with_index.sum(0) do |frame, i|
  if frame[0] == 10 && i <= 7
    if frames[i + 1][0] == 10
      10 + frames[i + 1][0] + frames[i + 2][0]
    else
      10 + frames[i + 1][0] + frames[i + 1][1]
    end
  elsif frame[0] == 10 && i == 8
    10 + frames[i + 1][0] + frames[i + 1][1]
  elsif frame.sum == 10 && i <= 8
    10 + frames[i + 1][0]
  else
    frame.sum
  end
end
puts point
