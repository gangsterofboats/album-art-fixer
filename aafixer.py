#!/usr/bin/env python
import argparse
import glob
from PIL import Image

# Parse the arguments
parser = argparse.ArgumentParser(description='Album art fixer')
parser.add_argument('-i', '--input', required=True, help='Input directory')
parser.add_argument('-o', '--output', required=True, help='Output directory')
options = parser.parse_args()

# Ensure the directory paths end in slashes
if (options.input[-1] != '/'):
    options.input = options.input + '/'
if (options.output[-1] != '/'):
    options.output = options.output + '/'

# Variable declaration
aarts = glob.glob(options.input + '**/AlbumArt.jpg', recursive=True)
not_square = []
not_big_enough = []

# Main part of script
for f in aarts:
    im = Image.open(f)
    aadim = { 'width' : im.size[0], 'height' : im.size[1] }

    # Check to ensure image is square
    if aadim['width'] != aadim['height']:
        not_square.append(f)

    # Check to ensure image is big enough
    if aadim['width'] < 1000 or aadim['height'] < 1000:
        not_big_enough.append(f)

# Write results of search to files
bfh = open(options.output + 'notbig.txt', 'w')
for bitem in not_big_enough:
    bfh.write("%s\n" % bitem)
bfh.close()

sfh = open(options.output + 'notsquare.txt', 'w')
for sitem in not_square:
    sfh.write("%s\n" % sitem)
sfh.close()
