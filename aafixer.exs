#!/usr/bin/env elixir
{options, _, _} = OptionParser.parse(System.argv(), switches: [input: :string, output: :string], aliases: [i: :input, o: :output])

# Ensure paths end in slashes
input_path = cond do
  String.last(options[:input]) != "/" -> options[:input] <> "/"
  true -> options[:input]
end
output_path = cond do
  String.last(options[:output]) != "/" -> options[:output] <> "/"
  true -> options[:output]
end

notBigF = Path.join(output_path, "notbig.txt")
notSqF = Path.join(output_path, "notsquare.txt")
{_, fbe} = File.open notBigF, [:append]
{_, fs} = File.open notSqF, [:append]

aarts = Path.wildcard(input_path <> "**/AlbumArt.jpg")
for f <- aarts do
    {aadims, _} = System.cmd("magick", ["identify", f])
    match = Regex.run(~r/\d+x\d+/, aadims)
    [width, height] = String.split(Enum.at(match, 0), "x")
    if width == height do
      IO.binwrite fs, "#{f}\n"
    end
    if String.to_integer(width) > 1000 || String.to_integer(height) > 1000 do
      IO.binwrite fbe, "#{f}\n"
    end
end

File.close fbe
File.close fs
