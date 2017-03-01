-- This script work fine with mpv, but can't work with gnome-mpv.

mputils = require 'mp.utils'

history = {
	json_file = ".config/gnome-mpv/play_history.json",
	last_file = "",
	last_fpos = "",
}

function load_last_stat()
	mp.osd_message("DEBUG: load_last_stat")
	local jsonfile = history.json_file
	local input_file = io.open(jsonfile, "r")
	local json_history = input_file:read()
	input_file:close()
	if json_history == "" or json_history == nil then
		return
	end
	history = mputils.parse_json(json_history)
	history.json_file = jsonfile

	local output_file = io.open("/tmp/mpv.debug.log", "w")
	output_file:write(history.last_file)
	output_file:close()

	--mp.osd_message("DEBUG: " .. mp.get_property("playlist"))
	mp.commandv("loadfile", history.last_file, "append-play", "start=" .. history.last_fpos)
	--mp.commandv("loadfile", history.last_file, "append-play")
	--mp.commandv("seek", history.last_fpos, "absolute")
end

function get_history()
	mp.osd_message("DEBUG: get_history")
	local pl_count = mp.get_property_number("playlist/count")

	if pl_count == 0 then
		load_last_stat()
	end
end

function auto_save_playing()
	mp.osd_message("DEBUG:")
	local last_file = mp.get_property("path")
	local last_fpos = mp.get_property("time-pos")
	if last_file ~= nil then
		history.last_file = last_file
	end
	if last_fpos ~= nil then
		history.last_fpos = last_fpos
	end

	local json_history = mputils.format_json(history)
	local output_file = io.open(history.json_file, "w")
	output_file:write(json_history)
	output_file:close()
end

--get_history()

--mp.register_event("", get_history)
timer = mp.add_timeout(2, get_history)
mp.register_event("seek", auto_save_playing)
mp.add_hook("on_unload", 0, auto_save_playing)

