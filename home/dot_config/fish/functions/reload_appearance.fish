function reload_appearance
  tmux source-file $XDG_CONFIG_HOME/tmux/tmux.conf; or true
  source $XDG_CONFIG_HOME/fish/conf.d/20-appearance.fish
  tide reload
  commandline -f repaint
  return 0
end
