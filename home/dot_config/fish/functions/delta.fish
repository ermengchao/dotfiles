function delta
  if is_dark_mode
    command delta --features=catppuccin-mocha $argv
  else
    command delta --features=catppuccin-latte $argv
  end
end
