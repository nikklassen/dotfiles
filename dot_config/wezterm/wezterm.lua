local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

config.color_scheme = 'Molokai'
config.font_size = 12

config.hide_tab_bar_if_only_one_tab = true
config.warn_about_missing_glyphs = false

config.audible_bell = 'Disabled'

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.enable_kitty_graphics = true

config.term = 'wezterm'

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make task numbers clickable
-- the first matched regex group is captured in $1.
table.insert(config.hyperlink_rules, {
  regex = [[\b(b|cl|go)/(\d+)\b]],
  format = 'http://$1/$2',
})

config.keys = {
  {
    key = 'U',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.QuickSelectArgs {
      label = 'open url',
      patterns = {
        [[\((?:\w+://\S+)\)]],
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
  {
    key = 'p',
    mods = 'CTRL|SHIFT',
    -- Send the escape sequence to make this work in tmux
    action = wezterm.action.SendString '\x1b[80;6u',
  },
  {
    key = 'P',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.ActivateCommandPalette,
  },
  {
    key = 'Return',
    mods = 'CTRL',
    -- Send the escape sequence to make this work in Windows
    action = wezterm.action.SendString '\x1b[13;5u',
  },
}

if #wezterm.default_wsl_domains() > 0 then
  config.default_domain = 'WSL:Ubuntu'
end

config.launch_menu = {}

if wezterm.target_triple:find('windows') then
  table.insert(config.launch_menu, {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
    domain = {
      DomainName = 'local',
    },
  })
end

local ok, local_config = pcall(require, 'wezterm-local')
if ok then
  config = local_config.configure(config)
end

return config
