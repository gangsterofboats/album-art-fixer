#!/usr/bin/env julia
# Parse arguments
inputpath = ARGS[2]
outputpath = ARGS[4]

# Ensure directory paths end in slashes
if inputpath[end] != '/'
    inputpath = inputpath * "/"
end

if outputpath[end] != '/'
    outputpath = outputpath * "/"
end

# Variable declaration
notsquare = String[]
notbigenough = String[]


# Main part of script
for (root, dirs, files) in walkdir(inputpath)
    aarts = filter(x -> contains(x, "AlbumArt.jpg"), files)
    for f in aarts
        aadim = Dict{String,String}()
        ffpath = joinpath(root, f)
        result = readstring(`magick identify $ffpath`)
        dims = match(r"\d+x\d+", result)
        (aadim["width"], aadim["height"]) = split(dims.match, "x")

        # Check if image is square
        if aadim["width"] != aadim["height"]
            push!(notsquare, ffpath)
        end

        # Check if image is big enough
        if parse(Int64, aadim["width"]) < 1000 || parse(Int64, aadim["height"]) < 1000
            push!(notbigenough, ffpath)
        end
    end
end

# Write results of search to files
writedlm(outputpath * "notbig.txt", notbigenough, "\n")
writedlm(outputpath * "notsquare.txt", notsquare, "\n")
