#!/usr/bin/escript
-export([main/1]).

main(Args) ->
    % Parse arguments
    InputP = lists:nth(2, Args),
    OutputP = lists:nth(4, Args),

    % Ensure paths end in slashes
    InputPa = case string:sub_string(InputP, length(InputP)) /= "/" of
                  true -> string:concat(InputP, "/");
                  false -> InputP
    end,
    OutputPa = case string:sub_string(OutputP, length(OutputP)) /= "/" of
                  true -> string:concat(OutputP, "/");
                  false -> OutputP
    end,
    Aas = filelib:fold_files(InputPa, ".*AlbumArt\.jpg", true, fun(File, Acc) -> [File|Acc] end, []),
    lists:foreach(fun(N) ->
                          album_art_fixer(N, OutputPa)
                  end, Aas).

% Function to run for each album art file
album_art_fixer(File, Path) ->
    Nbig = string:concat(Path, "notbig.txt"),
    Nsquare = string:concat(Path, "notsquare.txt"),
    Results = os:cmd(io_lib:format("magick identify \"~s\"", [File])),
    {_, [Capt]} = re:run(Results, " \\d+x\\d+ ", [{capture, first, binary}, global]),
    Captu = string:trim(Capt),
    [Width, Height] = string:split(Captu, "x"),
    if
        Width != Height -> file:write_file(Nsquare, io_lib:format("~s\n", [File]), [append])
    end,
    if
        (Width < 1000) or (Height < 1000) -> file:write_file(Nbig, io_lib:format("~s\n", [File]), [append])
    end.
