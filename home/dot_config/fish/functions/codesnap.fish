function codesnap
  if test $IS_DARK_MODE = true
    command codesnap --code-theme 'Catppuccin Mocha' $argv
  else
    command codesnap --code-theme 'Catppuccin Latte' $argv
  end
end
