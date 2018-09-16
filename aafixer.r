args <- commandArgs(TRUE)
inputPath <- args[2]
outputPath <- args[4]
if (substr(outputPath, nchar(outputPath), nchar(outputPath)) != "/")
{
    outputPath <- paste(outputPath, "/", sep="")
}

aarts <- dir(inputPath, pattern="AlbumArt.jpg", full.names=TRUE, recursive=TRUE)
notBigEnough <- list()
notSquare <- list()
for (f in aarts)
{
    cmd <- paste("magick identify \"", f, "\"", sep="")
    result <- system(cmd, intern=TRUE)
    m <- regexpr("\\d+x\\d+", result)
    ds <- regmatches(result, m)
    aadims <- strsplit(ds, split="x")[[1]]
    if (aadims[1] != aadims[2])
    {
        notSquare <- c(unlist(notSquare), f)
    }
    if (strtoi(aadims[1]) < 1000 || strtoi(aadims[2]) < 1000)
    {
        notBigEnough <- c(unlist(notBigEnough), f)
    }
}
nbf <- paste(outputPath, "notbig.txt", sep="")
nsf <- paste(outputPath, "notsquare.txt", sep="")
fbe <- file(nbf, open="w")
fns <- file(nsf, open="w")
writeLines(notBigEnough, fbe)
writeLines(notSquare, fns)
