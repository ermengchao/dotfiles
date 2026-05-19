function codesnap
  if test $IS_DARK_MODE = true
    command codesnap --config $XDG_CONFIG_HOME/codesnap/config-dark.json $argv
  else
    command codesnap --config $XDG_CONFIG_HOME/codesnap/config-light.json $argv
  end
end
