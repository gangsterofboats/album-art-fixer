#!/usr/bin/env perl
use strict;
use warnings;
use File::Find;
use Getopt::Long;
use Image::Size;
use feature qw{ say };

# Parse arguments
GetOptions(
    'input|i=s' => \my $input,
    'output|o=s' => \my $output
);
my %options = ( input => $input, output => $output );

# Ensure directory paths end in slashes
$options{input} .= '/' unless substr($options{input}, -1) =~ m/\//;
$options{output} .= '/' unless substr($options{output}, -1) =~ m/\//;

# Variable declaration
my @not_square;
my @not_big_enough;

# Sub to feed to File::Find sub
sub album_art_fixer
{
    my $file = $File::Find::name;

    if ($file =~ /AlbumArt\.jpg$/)
    {
        my %aadim;
        ($aadim{width}, $aadim{height}) = imgsize($file);

        if ($aadim{width} == $aadim{height})
        {
            push @not_square, $file;
        }

        if (($aadim{width} > 1000) || ($aadim{height} > 1000))
        {
            push @not_big_enough, $file;
        }
    }
}

# Main part of script
find(\&album_art_fixer, $options{input});
my %file_paths = ( notbig => $options{output} . 'notbig.txt', notsquare => $options{output} . 'notsquare.txt' );

open(my $bfh, '>', $file_paths{notbig});
foreach (@not_big_enough)
{
    say $bfh "$_";
}
close $bfh;

open(my $sfh, '>', $file_paths{notsquare});
foreach (@not_square)
{
    say $sfh "$_";
}
close $sfh;
