-- Save boomerang A-B clip
local utils = require("mp.utils")

local function save_boomerang()
	local function get_ab_range()
		local a = mp.get_property_number("ab-loop-a")
		local b = mp.get_property_number("ab-loop-b")
		if a and b then
			return a, b
		else
			mp.osd_message("No A-B loop set")
			return nil
		end
	end
	local function format_time(seconds)
		local h = math.floor(seconds / 3600)
		local m = math.floor((seconds % 3600) / 60)
		local s = math.floor(seconds % 60)
		return string.format("%02d-%02d-%02d", h, m, s)
	end
	local a, b = get_ab_range()
	if not a then
		return
	end

	local file = mp.get_property("path")
	local filename = file:match("^.+/(.+)$") or file
	local basename = filename:gsub("(.+)%..+$", "%1")
	local start_str = format_time(a)

	local home = os.getenv("HOME")
	local dir = home .. "/Videos/loops/"
	os.execute("mkdir -p " .. dir)

	local fwd = dir .. basename .. "_ab_" .. start_str .. "_fwd.mp4"
	local rev = dir .. basename .. "_ab_" .. start_str .. "_rev.mp4"
	local out = dir .. basename .. "_ab_" .. start_str .. "_boomerang.mp4"

	-- Forward clip
	local res1 = utils.subprocess({
		args = {
			"ffmpeg",
			"-i",
			file,
			"-ss",
			tostring(a),
			"-to",
			tostring(b),
			"-c:v",
			"libx264",
			"-c:a",
			"aac",
			"-y",
			fwd,
		},
		cancellable = false,
	})
	if res1.status ~= 0 then
		mp.osd_message("Failed saving forward part")
		return
	end

	-- Reverse clip
	local res2 = utils.subprocess({
		args = {
			"ffmpeg",
			"-i",
			fwd,
			"-vf",
			"reverse",
			"-af",
			"areverse",
			"-c:v",
			"libx264",
			"-c:a",
			"aac",
			"-y",
			rev,
		},
		cancellable = false,
	})
	if res2.status ~= 0 then
		mp.osd_message("Failed creating reverse part")
		return
	end

	-- Concat forward + reverse
	local concat_list = dir .. "concat_list.txt"
	local f = io.open(concat_list, "w")
	f:write("file '" .. fwd .. "'\n")
	f:write("file '" .. rev .. "'\n")
	f:close()

	local res3 = utils.subprocess({
		args = { "ffmpeg", "-f", "concat", "-safe", "0", "-i", concat_list, "-c", "copy", "-y", out },
		cancellable = false,
	})

	-- Cleanup
	os.remove(concat_list)
	os.remove(fwd)
	os.remove(rev)

	if res3.status == 0 then
		mp.osd_message("Saved boomerang to " .. out)
	else
		mp.osd_message("Failed to save boomerang")
	end
end

mp.add_key_binding("Ctrl+b", save_boomerang)
