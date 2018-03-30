#!/usr/bin/env crystal
require "option_parser"

# Parse arguments
options = {} of Symbol => String
OptionParser.parse! do |opts|
  opts.banner = "Usage: aafixer.cr --input PATH --output PATH"

  opts.on("-i", "--input PATH", "Input path") { |i| options[:input] = i }
  opts.on("-o", "--output PATH", "Output path") { |o| options[:output] = o }
end

# Ensure directory paths end in slashes
options[:input] += "/" unless options[:input][-1] == "/"
options[:output] += "/" unless options[:output][-1] == "/"

# Variable declaration
aarts = Dir.glob(options[:input] + "**/AlbumArt.jpg")
not_square = Array(String).new
not_big_enough = Array(String).new

# Main part of script
aarts.each do |f|
  aadim = {} of Symbol => Int32
  result = `magick identify "#{f}"`
  dims = result.match(/\d+x\d+/)
  if dims
    aadim[:width] = dims[0].split("x")[0].to_i
    aadim[:height] = dims[0].split("x")[1].to_i
  end

  # Check to ensure image is square
  if aadim[:width] != aadim[:height]
    not_square << f
  end

  # Check to ensure image is big enough
  if aadim[:width] < 1000 || aadim[:height] < 1000
    not_big_enough << f
  end
end

# Write results of search to files
onb = options[:output] + "notbig.txt"
bfh = File.new onb, "w"
not_big_enough.each { |line| bfh.puts line }
bfh.close

ons = options[:output] + "notsquare.txt"
sfh = File.new ons, "w"
not_square.each { |line| sfh.puts line }
sfh.close
