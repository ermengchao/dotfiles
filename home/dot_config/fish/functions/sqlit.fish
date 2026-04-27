function sqlit
  if type -q sqlit
    if is_dark_mode
      command sqlit --theme 'catppuccin-mocha' $argv
    else
      command sqlit --theme 'catppuccin-latte' $argv
    end
  end
end
