local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- FONT SETTINGS
config.font = wezterm.font("Hurmit Nerd Font")
config.font_size = 12.0

-- OPACITY SETTING
config.window_background_opacity = 0.85

-- COLOR SETTINGS
config.colors = {
	-- The default text color
	foreground = "#16A085",
	-- The default background color
	background = "#1E2229",

	-- The color of the cursor
	cursor_bg = "#44853A",
	cursor_fg = "#1E2229",
	cursor_border = "#44853A",

	-- The color of the selection
	selection_bg = "#FF2731",
	selection_fg = "#001e26",

	-- ANSI Colors (color0-7)
	ansi = {
		"#002731",
		"#d01b24",
		"#728905",
		"#a57705",
		"#2075c7",
		"#c61b6e",
		"#259185",
		"#e9e2cb",
	},

	-- Bright ANSI Colors (color8-15)
	brights = {
		"#16D885",
		"#bd3612",
		"#465a61",
		"#52676f",
		"#708183",
		"#5856b9",
		"#81908f",
		"#fcf4dc",
	},
}

config.max_fps = 120
-- config.front_end = "WebGpu"

return config
