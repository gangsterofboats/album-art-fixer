#!/usr/bin/env perl6
use File::Find;

sub MAIN (Str :i($input), Str :o($output))
{
    # Parse paths and ensure they end in slashes
    my %options = input => $input, output => $output;
    %options<input> = %options<input> ~ '/' unless %options<input>.match(/\/$/);
    %options<output> = %options<output> ~ '/' unless %options<output>.match(/\/$/);

    my ( @not_big_enough, @not_square );
    my %aadim;

    # Iterate over each album art file
    my @aarts = find(dir => %options<input>, name => /AlbumArt\.jpg/);
    for @aarts -> $file
    {
        my $result = qq:x/magick identify "$file"/;
        $result.match(/(\d+)x(\d+)/);
        %aadim{'width'} = split('x', $/)[0];
        %aadim{'height'} = split('x', $/)[1];

        if %aadim{'width'} != %aadim{'height'}
        {
            @not_square.push: $file.Str;
        }

        if %aadim{'width'} < 1000 or %aadim{'height'} < 1000
        {
            @not_big_enough.push: $file.Str;
        }
    }
    my $onb = %options<output> ~ 'notbig.txt';
    spurt $onb, @not_big_enough.join("\n");

    my $ons = %options<output> ~ 'notsquare.txt';
    spurt $ons, @not_square.join("\n");
}
