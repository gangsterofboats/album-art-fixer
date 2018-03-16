#!/usr/bin/env ruby
require 'fastimage'
require 'optparse'

# Parse arguments
options = {}
optparse = OptionParser.new do |opts|
  opts.banner = 'Usage: aafixer.rb --input PATH --output PATH'

  opts.on('-i', '--input PATH', 'Input path') do |i|
    options[:input] = i
  end

  opts.on('-o', '--output PATH', 'Output path') do |o|
    options[:output] = o
  end
end
optparse.parse!

# Ensure directory paths end in slashes
options[:input] += '/' unless options[:input][-1] == '/'
options[:output] += '/' unless options[:output][-1] == '/'

# Variable declaration
aarts = Dir.glob(options[:input] + '**/AlbumArt.jpg')
not_square = Array.new
not_big_enough = Array.new

# Main part of script
aarts.each do |f|
  aadim = { :width => FastImage.size(f)[0], :height => FastImage.size(f)[1] }

  # Check to ensure image is square
  if aadim[:width] != aadim[:height]
    not_square << File.absolute_path(f)
  end

  # Check to ensure image is big enough
  if aadim[:width] < 1000 or aadim[:height] < 1000
    not_big_enough << File.absolute_path(f)
  end
end

# Write results of search to files
IO.write(options[:output] + 'notbig.txt', not_big_enough.join("\n"))
IO.write(options[:output] + 'notsquare.txt', not_square.join("\n"))
