
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 30
config.font_size = 11.0

--config.color_scheme = "TokyoNight"
--config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "Gruvbox Material (Gogh)"

config.font = wezterm.font_with_fallback({
    "JetBrainsMonoNL Nerd Font Mono",
    "FiraCode Nerd Font Mono",
	"Consolas"
})

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = true
config.show_tabs_in_tab_bar = true
config.tab_max_width = 25
config.use_fancy_tab_bar = true

--config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_close_confirmation = "NeverPrompt"

config.mux_enable_ssh_agent = false

config.default_prog = { "C:/Program Files/PowerShell/7/pwsh.exe", "-NoLogo" }
config.launch_menu = {
	{ label = "Pwsh", args = { "C:/Program Files/PowerShell/7/pwsh.exe", "-NoLogo" } },
	{ label = "PowerShell", args = { "powershell.exe", "-NoLogo" } },
	{ label = "Command Prompt", args = { "cmd.exe" } },
	{ label = "Git Bash", args = { "C:/Program Files/Git/bin/bash.exe" } },
	{ label = "Neovim", args = { "nvim" } },
	{ label = "Claude Code", args = { "claude" } },
	{ label = "OpenCode", args = { "opencode" } },
	{ label = "CodeMaker", args = { "codemaker" } },

	{ label = "game", args = { "nvim", "H:/L10/server/game" } },
	{ label = "qnmlua", args = { "nvim", "H:/L10/Development/QnMobile/Assets/Scripts/lua" } },
	{ label = "patch", args = { "nvim", "H:/L10/patch" } },
	{ label = "sql", args = { "nvim", "H:/L10/server/game/server_common/database_schema" } },
	{ label = "saconfig", args = { "nvim", "H:/L10/server/etc/gas/SAConfig.lua" } },
	{ label = "pdef", args = { "nvim", "H:/L10/server/engine/src/ArkCodeGen/Properties" } },
	{ label = "logdef", args = { "nvim", "H:/L10/server/tools/autoGen/log" } },
	{ label = "ddef", args = { "nvim", "H:/L10/Development/BinaryDesignDataGen" } },
	{ label = "init.lua", args = { "nvim", "C:/Users/hzyangkai1/AppData/Local/nvim/lua/init.lua" } },

	{ label = "wezterm.lua", args = { "nvim", "C:/Users/hzyangkai1/.config/wezterm/wezterm.lua" } },
}

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelection("Clipboard"),
	},
	{
		event = { Up = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1500 }
config.keys = {
	{ key = "\\", mods = "LEADER", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },

    -- 快速切换Pane
    { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
	-- 调整Pane大小
	{ key = 'h', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Left', 5 }, },
	{ key = 'j', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Down', 5 }, },
	{ key = 'k', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Up', 5 }, },
	{ key = 'l', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Right', 5 }, },

	{ key = "\\", mods = "CTRL|ALT", action = wezterm.action.ShowLauncher },
	{ key = "w", mods = "CTRL|ALT", action = wezterm.action.CloseCurrentTab { confirm = true } },
	{ key = "n", mods = "CTRL|ALT", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
	{
		key = 's',
		mods = 'CTRL|ALT',
		action = wezterm.action_callback(function(win, pane)
			local tab, window = pane:move_to_new_window()
		end),
	},
	{
		key = 't',
		mods = 'CTRL|ALT',
		action = wezterm.action_callback(function(win, pane)
			local tab, window = pane:move_to_new_tab()
		end),
	},
	{
		key = 'f',
		mods = 'CTRL|ALT',
		action = wezterm.action.Multiple {
			wezterm.action.SendString 'fzf-open',
			wezterm.action.SendKey { key = 'Enter' },
		},
	},
	{
		key = 'e',
		mods = 'CTRL|ALT',
		action = wezterm.action.Multiple {
			wezterm.action.SendString 'es-open',
			wezterm.action.SendKey { key = 'Enter' },
		},
	},
}

for i = 1, 8 do
	-- CTRL + ALT + number to activate tab
	table.insert(config.keys, { key = tostring(i), mods = 'CTRL|ALT', action = wezterm.action.ActivateTab(i - 1) })
end
table.insert(config.keys, { key = 'LeftArrow', mods = 'CTRL|ALT', action = wezterm.action.ActivateTabRelative(-1) })
table.insert(config.keys, { key = 'RightArrow', mods = 'CTRL|ALT', action = wezterm.action.ActivateTabRelative(1) })

return config
