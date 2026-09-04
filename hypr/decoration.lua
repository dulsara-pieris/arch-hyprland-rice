hl.config({
	general = {
		gaps_in = 25,
		gaps_out = 30,

		border_size = 1,
col = {
        active_border = {
                colors = {
                        "rgba(ff1493ee)", -- DeepPink
                        "rgba(ff69b4ee)", -- HotPink
                },
                angle = 45
        },
        inactive_border = "rgba(595959aa)",
},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},
		blur = {
			enabled = true,
			-- variant = "frost", TODO after feature comes to lts
			-- if lucky drops :D
			size = 3,
			passes = 1,
			noise = 0.1,
			contrast = 0.8916,
			brightness = 0.8,
			vibrancy = 0.2696,
			new_optimizations = true,
		},
	},

	animations = {
		enabled = true,
	},
})
