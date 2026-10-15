local suppressMaximizeRule = hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.workspace_rule({
        workspace = "special:music",
        on_created_empty = "kitty --class music-scratchpad --title \"♥ Music\" -o background_opacity=0.93 -e ncmpcpp",
})

hl.window_rule({
        match = {
                class = "music-scratchpad",
        },
        float = true,
        size = "50% 40%",
        center = true,
})