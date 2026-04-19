if is_dark_mode
  alias btm "btm -C $XDG_CONFIG_HOME/bottom/catppuccin-mocha.toml"
  alias codesnap "codesnap --code-theme 'Catppuccin Mocha'"
  alias delta "delta --features=catppuccin-mocha"
  alias git "git -c delta.features=catppuccin-mocha"
  set -gx EZA_CONFIG_DIR $XDG_CONFIG_HOME/eza/catppuccin-mocha
  set -gx FZF_DEFAULT_OPTS "--exact --style full \
                            --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
                            --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
                            --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
                            --color=selected-bg:#45475A \
                            --color=border:#6C7086,label:#CDD6F4"
  set -gx LG_CONFIG_FILE $XDG_CONFIG_HOME/lazygit/config.yml,catppuccin-mocha.yml
  set -gx OPENCODE_TUI_CONFIG $XDG_CONFIG_HOME/opencode/catppuccin-mocha.json
  set -gx POSTING_THEME catppuccin-mocha
else
  alias btm "btm -C $XDG_CONFIG_HOME/bottom/catppuccin-latte.toml"
  alias codesnap "codesnap --code-theme 'Catppuccin Latte'"
  alias delta "delta --features=catppuccin-latte"
  alias git "git -c delta.features=catppuccin-latte"
  set -gx EZA_CONFIG_DIR $XDG_CONFIG_HOME/eza/catppuccin-latte
  set -gx FZF_DEFAULT_OPTS "--exact --style full \
                            --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
                            --color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
                            --color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
                            --color=selected-bg:#BCC0CC \
                            --color=border:#9CA0B0,label:#4C4F69"
  set -gx LG_CONFIG_FILE $XDG_CONFIG_HOME/lazygit/config.yml,catppuccin-latte.yml
  set -gx OPENCODE_TUI_CONFIG $XDG_CONFIG_HOME/opencode/catppuccin-latte.json
  set -gx POSTING_THEME catppuccin-latte
end
