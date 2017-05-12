-- This script work fine with mpv, but can't work with gnome-mpv.

mputils = require 'mp.utils'

local history = {
	json_file = ".config/gnome-mpv/play_history.json",
	last_file = "",
	last_fpos = "",
}

local stat = {
	didpause = "",
}

function load_last_stat()
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

	mp.commandv("loadfile", history.last_file, "append-play", "start=" .. history.last_fpos)
	stat.did_pause = "true"
end

-- [[ use this event function to workaround gnome-mpv's pause issue. ]]--
function check_did_pause_change()
	if stat.did_pause == "true" then
		mp.set_property_native("pause", true)
		stat.pause_on_start = "false"
	end
end

function get_history()
	local pl_count = mp.get_property_number("playlist/count")

	if pl_count == 0 then
		load_last_stat()
	end
end

function auto_save_playing()
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

timer = mp.add_timeout(1, get_history)

mp.register_event("seek", auto_save_playing)
mp.add_hook("on_unload", 0, auto_save_playing)
mp.register_event("file-loaded", check_did_pause_change)

