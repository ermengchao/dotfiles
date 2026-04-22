function codesnap
  if is_dark_mode
    command codesnap --code-theme 'Catppuccin Mocha' $argv
  else
    command codesnap --code-theme 'Catppuccin Latte' $argv
  end
end
