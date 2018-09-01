import std.algorithm;
import std.conv;
import std.file;
import std.getopt;
import std.process;
import std.regex;
import std.stdio;
import std.string;

// Struct to group getopt arguments
struct Op
{
    string inputPath;
    string outputPath;
}

void main(string[] args)
{
    Op options;
    getopt(
        args,
        "input|i", &options.inputPath,
        "output|o", &options.outputPath,
    );

    // Ensure directory paths end in slashes
    if (options.inputPath[options.inputPath.length - 1] != '/')
    {
        options.inputPath = options.inputPath ~ "/";
    }
    if (options.outputPath[options.outputPath.length - 1] != '/')
    {
        options.outputPath = options.outputPath ~ "/";
    }

    string[] notSquare;
    string[] notBigEnough;
    auto aarts = dirEntries(options.inputPath, SpanMode.depth).filter!(item => item.name.endsWith("AlbumArt.jpg"));
    foreach (a; aarts)
    {
        string[] aadim;

        auto stdo = executeShell(format("magick identify \"%s\"", a));
        auto mtch = matchFirst(stdo[1], regex(r"\d+x\d+"));
        aadim = mtch[0].split("x");
        if (aadim[0] == aadim[1])
        {
            notSquare ~= a;
        }
        if (to!int(aadim[0]) > 1000 || to!int(aadim[1]) > 1000)
        {
            notBigEnough ~= a;
        }
    }
    File fbe = File(options.outputPath ~ "notbig.txt", "w");
    File fns = File(options.outputPath ~ "notsquare.txt", "w");
    notBigEnough.each!(ln => fbe.writeln(ln));
    notSquare.each!(line => fns.writeln(line));
}
