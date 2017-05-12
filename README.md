# mpv-config

mpv config and scripts, applied in gnome-mpv.

## autoload.lua

This is taken from <https://github.com/kvineet/mpv-lua-scripts>, which taken from [original mpv repository](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua).

> This script automatically loads playlist entries before and after the the currently played file. It does so by scanning the directory a file is located in when starting playback. It sorts the directory entries alphabetically, and adds entries before and after the current file to the internal playlist.

Sorting method is modified to handle natural sort (e.g. file2.mkv added before file11.mkv etc.)

## last_file.lua (removed)

This is taken from <https://github.com/GoNZooo/mpv-scripts>, and modified the position test file to '~/.config/gnome-mpv/playlist_position.txt', so Windows should got error. just change it.

This script will automatically save and load playlist positions. It displays your current position in the playlist. Note that this does not save playlist positions based on individual playlists, but uses the same filename for all playlists.

## pause-when-minimize.lua

Official script: <https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/pause-when-minimize.lua>
This script does not work on gnome-mpv.

## loadonstart.lua

This script will load the last file and last position while the player is opened without any files.

