-- save_ab_clip.lua
-- Press Ctrl+s to save current A-B loop to ~/Videos/loops

local utils = require("mp.utils")
local msg = require("mp.msg")

function save_ab_clip()
	local a = mp.get_property_number("ab-loop-a")
	local b = mp.get_property_number("ab-loop-b")
	local file = mp.get_property("path")

	if not a or not b then
		mp.osd_message("No A-B loop set!")
		return
	end

	-- Expand home directory
	local home = os.getenv("HOME")
	local output_dir = home .. "/Videos/loops/"

	-- Ensure output directory exists
	os.execute("mkdir -p " .. output_dir)

	-- Build output filename
	local filename = file:match("^.+/(.+)$") -- extract filename
	local output = output_dir .. filename:gsub("(.+)%..+$", "%1_ab_clip.mp4")

	-- Run ffmpeg command to save segment
	local args = {
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
		output,
	}

	local res = utils.subprocess({ args = args, cancellable = false })
	if res.status == 0 then
		mp.osd_message("Saved A-B loop to " .. output)
	else
		mp.osd_message("Failed to save clip! See console.")
		msg.error(res.error)
	end
end

mp.add_key_binding("Ctrl+s", save_ab_clip)
