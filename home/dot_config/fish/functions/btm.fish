function btm
  if test $IS_DARK_MODE = true
    command btm -C $XDG_CONFIG_HOME/bottom/catppuccin-mocha.toml $argv
  else
    command btm -C $XDG_CONFIG_HOME/bottom/catppuccin-latte.toml $argv
  end
end
