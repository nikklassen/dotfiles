wezterm_config_dir="${XDG_CONFIG_HOME:-${HOME}}/wezterm"
if [[ ! -d "${wezterm_config_dir}" ]]; then
  mkdir "${wezterm_config_dir}"
fi
wezterm_config="${wezterm_config_dir}/wezterm.lua"
if [[ ! -f "${wezterm_config}" ]]; then
  cat <<EOF > "${wezterm_config}"
package.path = '${PWD}/?.lua;' .. package.path

local config = require('wezterm-base')

-- TODO: local customizations

return config
EOF
fi

