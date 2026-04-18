function reload_appearance
  source $XDG_CONFIG_HOME/fish/conf.d/appearance.fish
  sleep 1
  printf '\e]777;notify;;✨ Reload theme successfully.\a'
end
