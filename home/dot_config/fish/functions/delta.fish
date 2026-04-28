function delta
  if test $IS_DARK_MODE = true
    command delta --features=catppuccin-mocha $argv
  else
    command delta --features=catppuccin-latte $argv
  end
end
