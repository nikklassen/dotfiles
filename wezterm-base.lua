local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Molokai'
config.font_size = 12

config.hide_tab_bar_if_only_one_tab = true
config.warn_about_missing_glyphs = false

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make task numbers clickable
-- the first matched regex group is captured in $1.
table.insert(config.hyperlink_rules, {
    regex = [[\b(b|cl|go)/(\d+)\b]],
    format = 'http://$1',
})

config.keys = {
    {
        key = 'U',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.QuickSelectArgs {
            label = 'open url',
            patterns = {
                'https?://\\S+',
            },
            action = wezterm.action_callback(function(window, pane)
                local url = window:get_selection_text_for_pane(pane)
                wezterm.log_info('opening: ' .. url)
                wezterm.open_with(url)
            end),
        },
    },
    {
        key = 'PageUp',
        mods = 'SHIFT',
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = 'PageDown',
        mods = 'SHIFT',
        action = wezterm.action.DisableDefaultAssignment,
    },
}

if #wezterm.default_wsl_domains() > 0 then
    config.default_domain = 'WSL:Ubuntu'
end

return config
