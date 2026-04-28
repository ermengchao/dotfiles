function sqlit
  if type -q sqlit
    if test $IS_DARK_MODE = true
      command sqlit --theme 'catppuccin-mocha' $argv
    else
      command sqlit --theme 'catppuccin-latte' $argv
    end
  end
end
