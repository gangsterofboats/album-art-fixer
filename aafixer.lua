require 'lfs'

-- Parse arguments
inputpath = arg[2]
outputpath = arg[4]

-- Ensure directory paths end in slashes
if string.sub(inputpath, -1) ~= '/' then
   inputpath = inputpath .. '/'
end

if string.sub(outputpath, -1) ~= '/' then
   outputpath = outputpath .. '/'
end

notbigenough = {}
notsquare = {}

-- Main part of script
for artist in lfs.dir(inputpath) do
   if artist ~= "." and artist ~= ".." then
      for album in lfs.dir(inputpath .. artist) do
         if album ~= "." and album ~= ".." then
            for aart in lfs.dir(inputpath .. artist .. '/' .. album) do
               if aart:match("AlbumArt%.jpg$") then
                  ffpath = inputpath .. artist .. '/' .. album .. '/' .. aart
                  ch = io.popen('magick identify "' .. ffpath .. '"')
                  result = ch:read('*a')
                  dims = string.match(result, "%d+x%d+")
                  aadims = {}
                  for m in dims:gmatch("%d+") do
                     table.insert(aadims, m)
                  end
                  if aadims[1] != aadims[2] then
                     table.insert(notsquare, ffpath)
                  end
                  if (tonumber(aadims[1]) < 1000) or (tonumber(aadims[2]) < 1000) then
                     table.insert(notbigenough, ffpath)
                  end
               end
            end
         end
      end
   end
end
fbe = io.open(outputpath .. "notbig.txt", "w")
fns = io.open(outputpath .. "notsquare.txt", "w")
for i = 1, #notbigenough do
   fbe:write(notbigenough[i], "\n")
end
for i = 1, #notsquare do
   fns:write(notsquare[i], "\n")
end
fns:close()
fbe:close()
