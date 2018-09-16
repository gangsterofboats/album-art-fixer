#!/usr/bin/env nim
import os, osproc, parseopt, re, strutils

# Parse arguments
var options: tuple[inputPath: string, outputPath: string]
for kind, key, val in getopt():
  case kind
  of cmdArgument:
    continue
  of cmdLongOption, cmdShortOption:
    case key
    of "input", "i": options.inputPath = val
    of "output", "o": options.outputPath = val
  of cmdEnd: assert(false)

# Ensure directory paths end in slashes
if options.inputPath[^1] != '/':
  options.inputPath = options.inputPath & "/"
if options.outputPath[^1] != '/':
  options.outputPath = options.outputPath & "/"

# Variable declaration
var notSquare = newSeq[string](0)
var notBigEnough = newSeq[string](0)

# Main part of program
for file in walkDirRec(options.inputPath):
  if file.contains(re"AlbumArt") == true:
    var result = execProcess("magick identify \"$1\"" % [file])
    var aadims = result.findAll(re"\d+x\d+")[0].split(re"x")
    if aadims[0] == aadims[1]:
      notSquare.add(file)
    if parseInt(aadims[0]) > 1000 or parseInt(aadims[1]) > 1000:
      notBigEnough.add(file)

# Write results of search to files
var fbe = open(options.outputPath & "notbig.txt", fmWrite)
var fns = open(options.outputPath & "notsquare.txt", fmWrite)
for fi in notBigEnough:
  fbe.writeLine(fi)
for fl in notSquare:
  fns.writeLine(fl)
fns.close()
fbe.close()
